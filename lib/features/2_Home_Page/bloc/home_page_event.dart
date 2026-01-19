part of 'home_page_bloc.dart';

sealed class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

/// Event check auth (Token, User Info)
class HomeCheckAuthEvent extends HomePageEvent {}

class HomeFetchListStationEvent extends HomePageEvent {
  final String? search;
  final String? province;
  final String? commune;
  final String? district;
  final String? statusCodes;
  final int current;
  final int pageSize;

  const HomeFetchListStationEvent({
    this.search,
    this.province,
    this.commune,
    this.district,
    this.statusCodes,
    this.current = 1,
    this.pageSize = 5,
  });
}
