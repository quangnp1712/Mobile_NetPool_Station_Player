part of 'booking_page_bloc.dart';

sealed class BookingPageEvent extends Equatable {
  const BookingPageEvent();

  @override
  List<Object?> get props => [];
}

class BookingInitEvent extends BookingPageEvent {}

class LoadBookingDataEvent extends BookingPageEvent {}

class SearchStationEvent extends BookingPageEvent {
  final String query;
  const SearchStationEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterStationEvent extends BookingPageEvent {
  final String filterType;
  const FilterStationEvent(this.filterType);
  @override
  List<Object?> get props => [filterType];
}

class FindNearestStationEvent extends BookingPageEvent {}

class SelectStationEvent extends BookingPageEvent {
  final StationDetailModel station;
  const SelectStationEvent(this.station);
  @override
  List<Object?> get props => [station];
}

class ToggleStationSelectionModeEvent extends BookingPageEvent {}

class SelectSpaceEvent extends BookingPageEvent {
  final StationSpaceModel space;
  const SelectSpaceEvent(this.space);
  @override
  List<Object?> get props => [space];
}

class SelectAreaEvent extends BookingPageEvent {
  final AreaModel area;
  const SelectAreaEvent(this.area);
  @override
  List<Object?> get props => [area];
}

class SelectDateEvent extends BookingPageEvent {
  final int index;
  const SelectDateEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class SelectTimeEvent extends BookingPageEvent {
  final String time;
  const SelectTimeEvent(this.time);
  @override
  List<Object?> get props => [time];
}

class ChangeDurationEvent extends BookingPageEvent {
  final double delta;
  const ChangeDurationEvent(this.delta);
  @override
  List<Object?> get props => [delta];
}

class ToggleResourceEvent extends BookingPageEvent {
  final String resourceCode;
  const ToggleResourceEvent(this.resourceCode);
  @override
  List<Object?> get props => [resourceCode];
}

class SelectAutoPickEvent extends BookingPageEvent {}

class LoadProvincesEvent extends BookingPageEvent {}

class SelectProvinceEvent extends BookingPageEvent {
  final ProvinceModel province;
  const SelectProvinceEvent(this.province);
  @override
  List<Object?> get props => [province];
}

class SelectDistrictEvent extends BookingPageEvent {
  final DistrictModel district;
  const SelectDistrictEvent(this.district);
  @override
  List<Object?> get props => [district];
}

class ChangePageEvent extends BookingPageEvent {
  final int pageIndex;
  const ChangePageEvent(this.pageIndex);
  @override
  List<Object?> get props => [pageIndex];
}

// Event mới: Dùng chung để lấy danh sách station
class FetchStationsEvent extends BookingPageEvent {}

// Event mới: Reset bộ lọc
class ResetFilterEvent extends BookingPageEvent {}

class ConfirmBookingEvent extends BookingPageEvent {
  final String paymentMethodCode;
  final String paymentMethodName;
  const ConfirmBookingEvent(this.paymentMethodCode, this.paymentMethodName);
}

class GetWalletEvent extends BookingPageEvent {}
