part of 'menu_page_bloc.dart';

sealed class MenuPageEvent extends Equatable {
  const MenuPageEvent();

  @override
  List<Object> get props => [];
}

class MenuStarted extends MenuPageEvent {}

class MenuLogoutRequested extends MenuPageEvent {}
