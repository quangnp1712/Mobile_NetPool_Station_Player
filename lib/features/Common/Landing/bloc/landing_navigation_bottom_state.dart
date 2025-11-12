part of 'landing_navigation_bottom_bloc.dart';

sealed class LandingNavigationBottomState extends Equatable {
  const LandingNavigationBottomState();

  @override
  List<Object> get props => [];
}

class LandingNavigationBottomInitial extends LandingNavigationBottomState {
  final int bottomIndex;

  const LandingNavigationBottomInitial({required this.bottomIndex});
}

class TabChangeActionState extends LandingNavigationBottomInitial {
  TabChangeActionState({required super.bottomIndex});
}
