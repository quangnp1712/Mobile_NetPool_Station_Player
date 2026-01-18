// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_detail_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/2.station/station_detail_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/3.resource/resoucre_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/6.area/area_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/repository/booking_repository.dart';

part 'booking_history_event.dart';
part 'booking_history_state.dart';

class BookingHistoryBloc
    extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  BookingHistoryBloc()
      : super(BookingHistoryState(selectedDate: DateTime.now())) {
    on<InitBookingHistory>(_onInit);
    on<ChangeBookingFilter>(_onChangeFilter);
    on<SelectBookingDetailEvent>(_onSelectDetail);
    on<ChangeHistoryPage>(_onChangePage);
    on<ChangeMonthFilter>(_onChangeMonth);
    on<CancelBookingEvent>(_onCancelBooking);
    on<PayBookingEvent>(_onPayBooking);
  }

  Future<void> _fetchBookings(Emitter<BookingHistoryState> emit,
      {required int page}) async {
    emit(state.copyWith(status: BookingHistoryStatus.loading));
    try {
      String? statusCodeParam = state.filter == 'ALL' ? "" : state.filter;
      String accountId = AuthenticationPref.getAcountId().toString();
      final res = await BookingHistoryRepository().findAllBooking(
        accountId,
        state.dateFrom,
        state.dateTo,
        statusCodeParam,
        page.toString(),
        state.pageSize.toString(),
      );

      final response = BookingListModelResponse.fromMap(res["body"]);
      List<BookingModel> bookings = response.data ?? [];
      final meta = response.meta;

      // if (bookings.isNotEmpty) {
      //   bookings = await Future.wait(bookings.map((booking) async {
      //     try {
      //       // Default or from schedule if available
      //       String stationId = "2";
      //       if (booking.schedule?.stationId != null) {
      //         stationId = booking.schedule!.stationId.toString();
      //       }

      //       final stationRes =
      //           await BookingHistoryRepository().findDetailStation(stationId);
      //       if (stationRes['success'] == true && stationRes['data'] != null) {
      //         booking.station = StationDetailModel.fromMap(stationRes['data']);
      //       }
      //     } catch (_) {
      //       // Ignore error, display without station info or default
      //     }
      //     return booking;
      //   }));
      // }

      emit(state.copyWith(
        status: BookingHistoryStatus.success,
        bookings: bookings,
        currentPage: page,
        totalItems: meta?.total ?? 0,
      ));
    } catch (e) {
      emit(state.copyWith(status: BookingHistoryStatus.failure));
    }
  }

  Future<void> _onInit(
      InitBookingHistory event, Emitter<BookingHistoryState> emit) async {
    await _fetchBookings(emit, page: 0);
  }

  Future<void> _onChangeFilter(
      ChangeBookingFilter event, Emitter<BookingHistoryState> emit) async {
    emit(state.copyWith(filter: event.filter));
    await _fetchBookings(emit, page: 0);
  }

  Future<void> _onChangePage(
      ChangeHistoryPage event, Emitter<BookingHistoryState> emit) async {
    await _fetchBookings(emit, page: event.pageIndex);
  }

  Future<void> _onSelectDetail(
      SelectBookingDetailEvent event, Emitter<BookingHistoryState> emit) async {
    emit(state.copyWith(isLoadingDetail: true));
    try {
      final bookingRes = await BookingHistoryRepository()
          .findDetailBooking(event.bookingId.toString());
      final bookingDetail =
          BookingDetailModelResponse.fromMap(bookingRes["body"]).data;

      if (bookingDetail != null) {
        String stationId = "2";
        if (bookingDetail.schedule?.stationId != null) {
          stationId = bookingDetail.schedule!.stationId.toString();
        }

        final stationResult =
            await BookingHistoryRepository().findDetailStation(stationId);
        var stationResBody = stationResult["body"];
        if (stationResult['success'] == true) {
          StationDetailModelResponse stationDetailModelResponse =
              StationDetailModelResponse.fromJson(stationResBody);
          if (stationDetailModelResponse.data != null) {
            bookingDetail.station = stationDetailModelResponse.data;
          }
        }

        if (bookingDetail.stationResourceId != null) {
          final resourceRes = await BookingHistoryRepository()
              .getResouceDetail(bookingDetail.stationResourceId.toString());
          final resourceResponse =
              ResoucreModelResponse.fromMap(resourceRes["body"]);

          if (resourceResponse.data != null) {
            bookingDetail.stationResource = resourceResponse.data;

            if (bookingDetail.stationResource?.areaId != null) {
              final areaRes = await BookingHistoryRepository().getDetailArea(
                  bookingDetail.stationResource!.areaId.toString());
              final areaResponse =
                  AreaListModelResponse.fromMap(areaRes["body"]);
              if (areaResponse.data != null) {
                bookingDetail.area = areaResponse.data;
              }
            }
          }
        }
      }

      emit(state.copyWith(
        blocState: BlocState.showBookingDetail,
        selectedBooking: bookingDetail,
        isLoadingDetail: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingDetail: false));
      DebugLogger.printLog("Lỗi: $e");
    }
  }

  Future<void> _onChangeMonth(
      ChangeMonthFilter event, Emitter<BookingHistoryState> emit) async {
    emit(state.copyWith(selectedDate: event.date));
    await _fetchBookings(emit, page: 0);
  }

  Future<void> _onCancelBooking(
      CancelBookingEvent event, Emitter<BookingHistoryState> emit) async {
    emit(state.copyWith(actionStatus: BookingActionStatus.loading));
    try {
      final res = await BookingHistoryRepository()
          .cancelBooking(event.bookingId.toString());
      if (res['success'] == true) {
        emit(state.copyWith(
          actionStatus: BookingActionStatus.success,
          actionMessage: "Hủy đặt chỗ thành công",
        ));
        add(InitBookingHistory());
      } else {
        emit(state.copyWith(
          actionStatus: BookingActionStatus.failure,
          actionMessage: res['message'] ?? "Hủy thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: BookingActionStatus.failure,
        actionMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPayBooking(
      PayBookingEvent event, Emitter<BookingHistoryState> emit) async {
    emit(state.copyWith(actionStatus: BookingActionStatus.loading));
    try {
      Map<String, dynamic> res;
      if (event.paymentMethodCode == 'WALLET') {
        res = await BookingHistoryRepository()
            .paymentWallet(event.bookingId.toString());
        if (res["success"] == true) {
          DebugLogger.printLog("Thanh toán bằng ví hệ thống thành công");
        } else {
          DebugLogger.printLog(
              "Thanh toán bằng ví hệ thống thất bại: ${res["message"]}");
        }
      } else if (event.paymentMethodCode == 'BANK_TRANSFER') {
        res = await BookingHistoryRepository()
            .paymentBankTransfer(event.bookingId.toString());
        if (res["success"] == true) {
          DebugLogger.printLog("Thanh toán chuyển khoản thành công");
        } else {
          DebugLogger.printLog(
              "Thanh toán chuyển khoản thất bại: ${res["message"]}");
        }
      } else {
        throw Exception("Phương thức thanh toán không hỗ trợ online");
      }

      if (res['success'] == true || res['status'] == '200') {
        emit(state.copyWith(
          actionStatus: BookingActionStatus.success,
          actionMessage: "Thanh toán thành công",
        ));
        add(InitBookingHistory());
      } else {
        emit(state.copyWith(
          actionStatus: BookingActionStatus.failure,
          actionMessage: res['message'] ?? "Thanh toán thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        actionStatus: BookingActionStatus.failure,
        actionMessage: e.toString(),
      ));
    }
  }
}
