part of 'profile_page_bloc.dart';

sealed class ProfilePageEvent extends Equatable {
  const ProfilePageEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfilePageEvent {}

class ProfileUpdated extends ProfilePageEvent {
  final AccountInfoModel updatedInfo;
  const ProfileUpdated(this.updatedInfo);

  @override
  List<Object?> get props => [updatedInfo];
}

class ProfileEditToggled extends ProfilePageEvent {
  final bool isEditing;
  const ProfileEditToggled(this.isEditing);

  @override
  List<Object?> get props => [isEditing];
}

class ProfilePickAvatar extends ProfilePageEvent {}

class ProfileGenerateCaptcha extends ProfilePageEvent {}

class ProfileVerifyCaptcha extends ProfilePageEvent {
  final String input;
  const ProfileVerifyCaptcha(this.input);

  @override
  List<Object?> get props => [input];
}
