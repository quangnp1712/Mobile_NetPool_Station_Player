part of 'station_page_bloc.dart';

sealed class StationPageEvent extends Equatable {
  const StationPageEvent();

  @override
  List<Object> get props => [];
}

class InitStationPageEvent
    extends StationPageEvent {} // Load initial config (Provinces, Tags)

class FetchStationsEvent extends StationPageEvent {} // Call API List Stations

class SearchStationEvent extends StationPageEvent {
  final String query;
  const SearchStationEvent(this.query);
}

class SelectProvinceEvent extends StationPageEvent {
  final ProvinceModel province;
  const SelectProvinceEvent(this.province);
}

class SelectDistrictEvent extends StationPageEvent {
  final DistrictModel district;
  const SelectDistrictEvent(this.district);
}

class SelectTagEvent extends StationPageEvent {
  final String tag;
  const SelectTagEvent(this.tag);
}

class FindNearestStationEvent extends StationPageEvent {}

class ResetFilterEvent extends StationPageEvent {}

class ChangePageEvent extends StationPageEvent {
  final int pageIndex;
  const ChangePageEvent(this.pageIndex);
}
