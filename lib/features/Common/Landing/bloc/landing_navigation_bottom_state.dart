// ignore_for_file: camel_case_types

part of 'landing_navigation_bottom_bloc.dart';

sealed class LandingNavigationBottomState {}

class LandingNavigationBottomInitial extends LandingNavigationBottomState {
  final int bottomIndex;

  LandingNavigationBottomInitial({required this.bottomIndex});
}

class TabChangeActionState extends LandingNavigationBottomInitial {
  TabChangeActionState({required super.bottomIndex});
}
