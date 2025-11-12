import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'landing_navigation_bottom_event.dart';
part 'landing_navigation_bottom_state.dart';

class LandingNavigationBottomBloc
    extends Bloc<LandingNavigationBottomEvent, LandingNavigationBottomInitial> {
  LandingNavigationBottomBloc()
      : super(LandingNavigationBottomInitial(bottomIndex: 0)) {
    on<LandingNavigationBottomInitialEvent>(
        _landingNavigationBottomInitialEvent);
    on<LandingNavigationBottomTabChangeEvent>(
        _landingNavigationBottomTabChangeEvent);
  }

  FutureOr<void> _landingNavigationBottomInitialEvent(
      LandingNavigationBottomInitialEvent event,
      Emitter<LandingNavigationBottomState> emit) {}

  FutureOr<void> _landingNavigationBottomTabChangeEvent(
      LandingNavigationBottomTabChangeEvent event,
      Emitter<LandingNavigationBottomState> emit) {
    emit(TabChangeActionState(bottomIndex: event.bottomIndex));
  }
}
