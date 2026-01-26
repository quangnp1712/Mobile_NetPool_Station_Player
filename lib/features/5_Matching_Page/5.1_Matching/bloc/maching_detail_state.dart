part of 'maching_detail_bloc.dart';

enum MatchingStatus { initial, loading, success, failure }

enum MatchingActionStatus { idle, loading, success, failure }

class MatchingDetailState extends Equatable {
  final MatchingStatus status; // Trạng thái tải trang chính
  final MatchingActionStatus
      actionStatus; // Trạng thái khi bấm nút (Join/Approve)

  final MatchMakingModel? data; // Dữ liệu chi tiết phòng
  final List<MatchMakingJoinModel> joinRequests; // Danh sách yêu cầu (cho Host)

  final String errorMessage;
  final String
      actionMessage; // Thông báo kết quả hành động (vd: "Tham gia thành công")

  // Role flags
  final bool isHost;
  final bool isMember;
  final int? currentAccountId;

  const MatchingDetailState({
    this.status = MatchingStatus.initial,
    this.actionStatus = MatchingActionStatus.idle,
    this.data,
    this.joinRequests = const [],
    this.errorMessage = '',
    this.actionMessage = '',
    this.isHost = false,
    this.isMember = false,
    this.currentAccountId,
  });

  MatchingDetailState copyWith({
    MatchingStatus? status,
    MatchingActionStatus? actionStatus,
    MatchMakingModel? data,
    List<MatchMakingJoinModel>? joinRequests,
    String? errorMessage,
    String? actionMessage,
    bool? isHost,
    bool? isMember,
    int? currentAccountId,
  }) {
    return MatchingDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      data: data ?? this.data,
      joinRequests: joinRequests ?? this.joinRequests,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
      isHost: isHost ?? this.isHost,
      isMember: isMember ?? this.isMember,
      currentAccountId: currentAccountId ?? this.currentAccountId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        data,
        joinRequests,
        errorMessage,
        actionMessage,
        isHost,
        isMember,
        currentAccountId
      ];
}
