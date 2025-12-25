part of 'profile_page_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  updateSuccess
}

class ProfilePageState extends Equatable {
  final ProfileStatus status;
  final AccountInfoModel? accountInfo;
  final String? message;
  final bool isEditing;

  // Fields cho Avatar & Captcha
  final bool isPickingImage;
  final String captchaText;
  final bool isCaptchaVerified;
  final bool isVerifyingCaptcha;
  final bool isClearCaptchaController;

  const ProfilePageState({
    this.status = ProfileStatus.initial,
    this.accountInfo,
    this.message,
    this.isEditing = false,
    this.isPickingImage = false,
    this.captchaText = '',
    this.isCaptchaVerified = false,
    this.isVerifyingCaptcha = false,
    this.isClearCaptchaController = false,
  });

  ProfilePageState copyWith({
    ProfileStatus? status,
    AccountInfoModel? accountInfo,
    String? message,
    bool? isEditing,
    bool? isPickingImage,
    String? captchaText,
    bool? isCaptchaVerified,
    bool? isVerifyingCaptcha,
    bool? isClearCaptchaController,
  }) {
    return ProfilePageState(
      status: status ?? ProfileStatus.initial,
      accountInfo: accountInfo ?? this.accountInfo,
      message: message ?? this.message,
      isEditing: isEditing ?? this.isEditing,
      isPickingImage: isPickingImage ?? this.isPickingImage,
      captchaText: captchaText ?? this.captchaText,
      isCaptchaVerified: isCaptchaVerified ?? this.isCaptchaVerified,
      isVerifyingCaptcha: isVerifyingCaptcha ?? this.isVerifyingCaptcha,
      isClearCaptchaController:
          isClearCaptchaController ?? false, // Reset flag one-shot
    );
  }

  @override
  List<Object?> get props => [
        status,
        accountInfo,
        message,
        isEditing,
        isPickingImage,
        captchaText,
        isCaptchaVerified,
        isVerifyingCaptcha,
        isClearCaptchaController
      ];
}
