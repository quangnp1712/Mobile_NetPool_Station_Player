part of 'landing_navigation_bottom_bloc.dart';

sealed class LandingNavigationBottomEvent extends Equatable {
  const LandingNavigationBottomEvent();

  @override
  List<Object> get props => [];
}

class LandingNavigationBottomInitialEvent
    extends LandingNavigationBottomEvent {}

class LandingNavigationBottomTabChangeEvent
    extends LandingNavigationBottomEvent {
  final int bottomIndex;

  const LandingNavigationBottomTabChangeEvent({required this.bottomIndex});
}
