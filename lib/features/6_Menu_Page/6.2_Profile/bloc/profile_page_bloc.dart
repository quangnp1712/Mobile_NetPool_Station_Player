// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_model.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_response_model.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/repository/profile_repository.dart';

part 'profile_page_event.dart';
part 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc() : super(ProfilePageState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileEditToggled>(_onEditToggled);
    on<ProfileUpdated>(_onUpdated);
    on<ProfilePickAvatar>(_onPickAvatar);
    on<ProfileGenerateCaptcha>(_onGenerateCaptcha);
    on<ProfileVerifyCaptcha>(_onVerifyCaptcha);
  }
  Future<void> _onStarted(
      ProfileStarted event, Emitter<ProfilePageState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      String accountId = AuthenticationPref.getAcountId().toString();

      if (accountId == "" || accountId == "0") {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          message: "Lỗi vui lòng thử lại",
        ));
        DebugLogger.printLog("Lỗi: không có accountID ");
        return;
      }

      //! A.  gọi API lấy chi tiết player
      AccountInfoModel _player;
      var results = await ProfileRepository().getProfile(accountId);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        AccountInfoModelResponse resultsBody =
            AccountInfoModelResponse.fromJson(responseBody);
        if (resultsBody.data != null) {
          _player = resultsBody.data!;
          emit(state.copyWith(
            status: ProfileStatus.success,
            accountInfo: _player,
          ));
        } else {
          DebugLogger.printLog("Lỗi: $responseMessage ");
          emit(state.copyWith(
            status: ProfileStatus.failure,
            message: "Lỗi vui lòng thử lại",
          ));
        }
      } else {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          message: "Lỗi vui lòng thử lại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failure, message: "Lỗi tải thông tin"));
      DebugLogger.printLog("Lỗi: $e ");
    }
  }

  void _onEditToggled(
      ProfileEditToggled event, Emitter<ProfilePageState> emit) {
    String newCaptcha = event.isEditing ? _generateRandomCaptcha() : '';
    emit(state.copyWith(
      isEditing: event.isEditing,
      captchaText: newCaptcha,
      isCaptchaVerified: false,
    ));
  }

  Future<void> _onUpdated(
      ProfileUpdated event, Emitter<ProfilePageState> emit) async {
    if (state.isEditing && !state.isCaptchaVerified) {
      emit(state.copyWith(
          status: ProfileStatus.failure,
          message: "Vui lòng xác thực CAPTCHA!"));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.updating));
    try {
      String? finalAvatarUrl = event.updatedInfo.avatar;

      if (finalAvatarUrl != null && finalAvatarUrl.startsWith('data:image')) {
        finalAvatarUrl = await _uploadImagesToFirebase(finalAvatarUrl);
      }

      final infoToUpdate = event.updatedInfo.copyWith(avatar: finalAvatarUrl);

      await Future.delayed(const Duration(seconds: 1));
      DebugLogger.printLog("API Update Body: ${infoToUpdate.toJson()}");

      emit(state.copyWith(
        status: ProfileStatus.updateSuccess,
        accountInfo: infoToUpdate,
        message: "Cập nhật thành công!",
        isEditing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failure, message: "Lỗi cập nhật: $e"));
    }
  }

  Future<void> _onPickAvatar(
      ProfilePickAvatar event, Emitter<ProfilePageState> emit) async {
    emit(state.copyWith(isPickingImage: true));
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        String base64String = base64Encode(result.files.single.bytes!);
        String ext = result.files.single.extension ?? 'png';
        String dataUri = "data:image/$ext;base64,$base64String";

        final currentInfo = state.accountInfo ?? AccountInfoModel();
        emit(state.copyWith(
          isPickingImage: false,
          accountInfo: currentInfo.copyWith(avatar: dataUri),
        ));
      } else {
        emit(state.copyWith(isPickingImage: false));
      }
    } catch (e) {
      DebugLogger.printLog("Pick avatar error: $e");
      emit(state.copyWith(isPickingImage: false));
    }
  }

  void _onGenerateCaptcha(
      ProfileGenerateCaptcha event, Emitter<ProfilePageState> emit) {
    emit(state.copyWith(
        captchaText: _generateRandomCaptcha(),
        isCaptchaVerified: false,
        isClearCaptchaController: true));
  }

  void _onVerifyCaptcha(
      ProfileVerifyCaptcha event, Emitter<ProfilePageState> emit) {
    emit(state.copyWith(isVerifyingCaptcha: true));

    bool isValid = event.input == state.captchaText;
    emit(state.copyWith(
        isCaptchaVerified: isValid,
        isVerifyingCaptcha: false,
        isClearCaptchaController: !isValid));
  }

  String _generateRandomCaptcha() {
    return Random().nextInt(999999).toString().padLeft(6, '0');
  }

  Future<String> _uploadImagesToFirebase(String base64Images) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    String uploadedUrl = "";

    try {
      final String base64String = base64Images.split(',').last;
      final Uint8List imageBytes = base64Decode(base64String);

      final String fileName =
          'user_avatar/avatar_${DateTime.now().millisecondsSinceEpoch}.png';

      final Reference ref = storage.ref().child(fileName);

      final SettableMetadata metadata =
          SettableMetadata(contentType: 'image/png');
      await ref.putData(imageBytes, metadata);

      uploadedUrl = await ref.getDownloadURL();
    } catch (e) {
      DebugLogger.printLog("Lỗi upload ảnh: $e");
      throw Exception("Upload ảnh thất bại");
    }
    return uploadedUrl;
  }
}
