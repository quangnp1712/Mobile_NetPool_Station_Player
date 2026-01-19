part of 'home_page_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomePageState extends Equatable {
  final HomeStatus stationListStatus;
  final List<StationDetailModel> stations;
  final StationListMetaModel? stationMeta;
  final String message;

  // Auth State
  final bool isLoggedIn;
  final String userName;

  const HomePageState({
    this.stationListStatus = HomeStatus.initial,
    this.stations = const [],
    this.stationMeta,
    this.message = '',
    this.isLoggedIn = false,
    this.userName = '',
  });

  HomePageState copyWith({
    HomeStatus? stationListStatus,
    List<StationDetailModel>? stations,
    StationListMetaModel? stationMeta,
    String? message,
    bool? isLoggedIn,
    String? userName,
  }) {
    return HomePageState(
      stationListStatus: stationListStatus ?? HomeStatus.initial,
      stations: stations ?? this.stations,
      stationMeta: stationMeta ?? this.stationMeta,
      message: message ?? "",
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [
        stationListStatus,
        stations,
        stationMeta,
        message,
        isLoggedIn,
        userName,
      ];
}
