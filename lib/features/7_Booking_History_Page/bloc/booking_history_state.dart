part of 'booking_history_bloc.dart';

enum BookingHistoryStatus { initial, loading, success, failure }

enum BlocState { initial, showBookingDetail }

enum BookingActionStatus { initial, loading, success, failure }

class BookingHistoryState extends Equatable {
  final BookingHistoryStatus status;
  final BlocState blocState;
  final List<BookingModel> bookings;
  final String filter;
  final BookingModel? selectedBooking;
  final bool isLoadingDetail;
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final DateTime selectedDate;

  final BookingActionStatus actionStatus;
  final String? actionMessage;

  final String? paymentUrl; 


  const BookingHistoryState({
    this.status = BookingHistoryStatus.initial,
    this.blocState = BlocState.initial,
    this.bookings = const [],
    this.filter = 'ALL',
    this.selectedBooking,
    this.isLoadingDetail = false,
    this.currentPage = 0,
    this.totalItems = 0,
    this.pageSize = 5,
    required this.selectedDate,
    this.actionStatus = BookingActionStatus.initial,
    this.actionMessage,
    this.paymentUrl,

  });

  // Calculate Date From (First day of month)
  String get dateFrom {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    return DateFormat('yyyy-MM-dd').format(firstDay);
  }

  // Calculate Date To (Last day of month)
  String get dateTo {
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    return DateFormat('yyyy-MM-dd').format(lastDay);
  }

  BookingHistoryState copyWith({
    BookingHistoryStatus? status,
    BlocState? blocState,
    List<BookingModel>? bookings,
    String? filter,
    BookingModel? selectedBooking,
    bool? isLoadingDetail,
    int? currentPage,
    int? totalItems,
    int? pageSize,
    DateTime? selectedDate,
    BookingActionStatus? actionStatus,
    String? actionMessage,
    String? paymentUrl,

  }) {
    return BookingHistoryState(
      status: status ?? BookingHistoryStatus.initial,
      blocState: blocState ?? BlocState.initial,
      bookings: bookings ?? this.bookings,
      filter: filter ?? this.filter,
      selectedBooking: selectedBooking ?? this.selectedBooking,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      selectedDate: selectedDate ?? this.selectedDate,
      actionStatus: actionStatus ?? BookingActionStatus.initial,
      actionMessage: actionMessage ?? this.actionMessage,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookings,
        filter,
        selectedBooking,
        isLoadingDetail,
        currentPage,
        totalItems,
        pageSize,
        selectedDate,
        actionStatus,
        actionMessage,
        paymentUrl,
      ];
}
