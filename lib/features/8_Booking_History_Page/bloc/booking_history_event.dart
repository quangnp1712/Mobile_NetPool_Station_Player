part of 'booking_history_bloc.dart';

abstract class BookingHistoryEvent extends Equatable {
  const BookingHistoryEvent();
  @override
  List<Object?> get props => [];
}

class InitBookingHistory extends BookingHistoryEvent {}

class ChangeBookingFilter extends BookingHistoryEvent {
  final String filter;
  const ChangeBookingFilter(this.filter);
  @override
  List<Object?> get props => [filter];
}

class SelectBookingDetailEvent extends BookingHistoryEvent {
  final int bookingId;
  const SelectBookingDetailEvent(this.bookingId);
}

class ChangeHistoryPage extends BookingHistoryEvent {
  final int pageIndex;
  const ChangeHistoryPage(this.pageIndex);
  @override
  List<Object?> get props => [pageIndex];
}

class ChangeMonthFilter extends BookingHistoryEvent {
  final DateTime date;
  const ChangeMonthFilter(this.date);
  @override
  List<Object?> get props => [date];
}

class CancelBookingEvent extends BookingHistoryEvent {
  final int bookingId;
  const CancelBookingEvent(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class PayBookingEvent extends BookingHistoryEvent {
  final int bookingId;
  final String paymentMethodCode;
  const PayBookingEvent(this.bookingId, this.paymentMethodCode);
  @override
  List<Object?> get props => [bookingId, paymentMethodCode];
}
