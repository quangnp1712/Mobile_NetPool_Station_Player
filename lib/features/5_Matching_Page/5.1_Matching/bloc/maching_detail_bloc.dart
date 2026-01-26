import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_detail_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/repository/matching_repository.dart';

part 'maching_detail_event.dart';
part 'maching_detail_state.dart';

class MatchingDetailBloc
    extends Bloc<MatchingDetailEvent, MatchingDetailState> {
  final MatchingRepository _repo;

  MatchingDetailBloc(
    this._repo,
  ) : super(const MatchingDetailState()) {
    on<MatchingDetailInitEvent>(_onInit);
    on<MatchingDetailJoinRoomEvent>(_onJoinRoom);
    on<MatchingDetailLoadRequestsEvent>(_onLoadRequests);
    on<MatchingDetailApproveEvent>(_onApproveRequest);
  }

  // Logic: Tải dữ liệu ban đầu
  Future<void> _onInit(
    MatchingDetailInitEvent event,
    Emitter<MatchingDetailState> emit,
  ) async {
    emit(state.copyWith(status: MatchingStatus.loading));

    try {
      // 1. Lấy Account ID local
      final accountId = AuthenticationPref.getAcountId();

      // 2. Gọi API lấy chi tiết
      final result = await _repo.findDetail(event.matchMakingId.toString());

      if (result['success'] == true && result['body']['data'] != null) {
        MatchMakingDetailModelResponse body =
            MatchMakingDetailModelResponse.fromMap(result['body']);
        MatchMakingModel newData = body.data!;

        // 3. Tính toán Role
        bool isHost = false;
        bool isMember = false;

        if (newData.participants != null && accountId != null) {
          for (var p in newData!.participants!) {
            if (p.accountId == accountId) {
              if (p.typeCode == "HOST") {
                isHost = true;
              } else {
                isMember = true;
              }
              break;
            }
          }
        }

        emit(state.copyWith(
          status: MatchingStatus.success,
          data: newData,
          currentAccountId: accountId,
          isHost: isHost,
          isMember: isMember,
        ));
      } else {
        emit(state.copyWith(
          status: MatchingStatus.failure,
          errorMessage: result['message'] ?? "Không thể tải dữ liệu phòng.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MatchingStatus.failure,
        errorMessage: "Đã xảy ra lỗi hệ thống: $e",
      ));
    }
  }

  // Logic: Tham gia phòng
  Future<void> _onJoinRoom(
    MatchingDetailJoinRoomEvent event,
    Emitter<MatchingDetailState> emit,
  ) async {
    if (state.data == null) return;

    emit(state.copyWith(actionStatus: MatchingActionStatus.loading));

    try {
      MatchMakingModel matchMakingId =
          MatchMakingModel(matchMakingId: state.data!.matchMakingId);
      final result = await _repo.join(matchMakingId);

      if (result['success'] == true) {
        emit(state.copyWith(
          actionStatus: MatchingActionStatus.success,
          actionMessage: "Gửi yêu cầu tham gia thành công!",
        ));
        // Reset action status sau khi xử lý xong UI
        emit(state.copyWith(actionStatus: MatchingActionStatus.idle));

        // Reload lại data để cập nhật UI nếu cần (tùy nghiệp vụ)
        if (state.data?.matchMakingId != null) {
          add(MatchingDetailInitEvent(state.data!.matchMakingId!));
        }
      } else {
        emit(state.copyWith(
          actionStatus: MatchingActionStatus.failure,
          errorMessage: result['message'] ?? "Tham gia thất bại.",
        ));
        emit(state.copyWith(actionStatus: MatchingActionStatus.idle));
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: MatchingActionStatus.failure,
        errorMessage: "Lỗi kết nối: $e",
      ));
      emit(state.copyWith(actionStatus: MatchingActionStatus.idle));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  // Logic: Tải danh sách yêu cầu (Cho Host)
  Future<void> _onLoadRequests(
    MatchingDetailLoadRequestsEvent event,
    Emitter<MatchingDetailState> emit,
  ) async {
    if (state.data?.matchMakingId == null) return;

    // Lưu ý: Có thể thêm status loading riêng cho list nếu muốn, ở đây dùng tạm actionStatus hoặc chỉ update list
    // Để đơn giản, ta chỉ update list, UI sẽ dùng FutureBuilder hoặc BlocBuilder
    try {
      final result = await _repo.findJoin(state.data!.matchMakingId.toString());

      if (result['success'] == true && result['data'] != null) {
        List<dynamic> rawList = result['data'];
        final requests =
            rawList.map((e) => MatchMakingJoinModel.fromMap(e)).toList();

        emit(state.copyWith(joinRequests: requests));
      }
    } catch (e) {
      // Silent error hoặc log
      print("Lỗi tải danh sách request: $e");
    }
  }

  // Logic: Duyệt/Từ chối yêu cầu
  Future<void> _onApproveRequest(
    MatchingDetailApproveEvent event,
    Emitter<MatchingDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: MatchingActionStatus.loading));

    try {
      final result =
          await _repo.approveJoin(event.registrationId, event.action);

      if (result['success'] == true) {
        emit(state.copyWith(
          actionStatus: MatchingActionStatus.success,
          actionMessage: event.action == 'accept'
              ? "Đã chấp nhận thành viên!"
              : "Đã từ chối yêu cầu.",
        ));
        emit(state.copyWith(actionStatus: MatchingActionStatus.idle));

        // Reload data để cập nhật danh sách participants
        if (state.data?.matchMakingId != null) {
          add(MatchingDetailInitEvent(state.data!.matchMakingId!));
          // Reload luôn danh sách request
          add(MatchingDetailLoadRequestsEvent());
        }
      } else {
        emit(state.copyWith(
          actionStatus: MatchingActionStatus.failure,
          errorMessage: result['message'] ?? "Xử lý thất bại.",
        ));
        emit(state.copyWith(actionStatus: MatchingActionStatus.idle));
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: MatchingActionStatus.failure,
        errorMessage: "Lỗi hệ thống: $e",
      ));
      emit(state.copyWith(actionStatus: MatchingActionStatus.idle));
    }
  }
}
