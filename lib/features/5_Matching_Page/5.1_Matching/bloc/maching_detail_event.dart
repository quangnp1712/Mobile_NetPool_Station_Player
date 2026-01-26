part of 'maching_detail_bloc.dart';

abstract class MatchingDetailEvent extends Equatable {
  const MatchingDetailEvent();
  @override
  List<Object?> get props => [];
}

// Event khi mới vào màn hình
class MatchingDetailInitEvent extends MatchingDetailEvent {
  final int matchMakingId;
  const MatchingDetailInitEvent(this.matchMakingId);
  @override
  List<Object?> get props => [matchMakingId];
}

// Event khi người dùng muốn tham gia phòng
class MatchingDetailJoinRoomEvent extends MatchingDetailEvent {}

// Event khi Host muốn tải danh sách yêu cầu tham gia
class MatchingDetailLoadRequestsEvent extends MatchingDetailEvent {}

// Event khi Host duyệt hoặc từ chối yêu cầu
class MatchingDetailApproveEvent extends MatchingDetailEvent {
  final String registrationId;
  final String action; // 'accept' or 'deny'
  const MatchingDetailApproveEvent(this.registrationId, this.action);
  @override
  List<Object?> get props => [registrationId, action];
}
