part of 'create_room_bloc.dart';

abstract class CreateRoomEvent {}

class InitPage extends CreateRoomEvent {}

class FetchStationsEvent extends CreateRoomEvent {}

class SearchStationEvent extends CreateRoomEvent {
  final String query;
  SearchStationEvent(this.query);
}

class SelectProvinceEvent extends CreateRoomEvent {
  final String province;
  SelectProvinceEvent(this.province);
}

class SelectDistrictEvent extends CreateRoomEvent {
  final String district;
  SelectDistrictEvent(this.district);
}

class ResetFilterEvent extends CreateRoomEvent {}

class ChangePageEvent extends CreateRoomEvent {
  final int page;
  ChangePageEvent(this.page);
}

class FindNearestStationEvent extends CreateRoomEvent {}

class SelectStation extends CreateRoomEvent {
  final StationDetailModel station;
  SelectStation(this.station);
}

class SelectSpace extends CreateRoomEvent {
  final StationSpaceModel space;
  SelectSpace(this.space);
}

class SelectGame extends CreateRoomEvent {
  final GameModel game;
  SelectGame(this.game);
}

class SelectDate extends CreateRoomEvent {
  final ScheduleModel schedule;
  SelectDate(this.schedule);
}

class SelectTimeSlot extends CreateRoomEvent {
  final TimeslotModel timeSlot;
  SelectTimeSlot(this.timeSlot);
}

class SelectArea extends CreateRoomEvent {
  final AreaModel area;
  SelectArea(this.area);
}

class ChangeDuration extends CreateRoomEvent {
  final double duration;
  ChangeDuration(this.duration);
}

class SearchResources extends CreateRoomEvent {}

class ToggleResource extends CreateRoomEvent {
  final StationResourceModel resource;
  ToggleResource(this.resource);
}

class ChangeHoldingDays extends CreateRoomEvent {
  final int days;
  ChangeHoldingDays(this.days);
}

class SelectPaymentMethod extends CreateRoomEvent {
  final String method;
  SelectPaymentMethod(this.method);
}

class SubmitBooking extends CreateRoomEvent {}
