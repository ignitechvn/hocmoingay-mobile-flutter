import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationResponseDto {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'params')
  final Map<String, dynamic>? params;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'createdDate')
  final String createdDate;

  @JsonKey(name: 'updateDate')
  final String? updateDate;

  @JsonKey(name: 'deliveredAt')
  final String? deliveredAt;

  @JsonKey(name: 'readAt')
  final String? readAt;

  NotificationResponseDto({
    required this.id,
    required this.userId,
    this.params,
    required this.type,
    required this.createdDate,
    this.updateDate,
    this.deliveredAt,
    this.readAt,
  });

  factory NotificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseDtoToJson(this);

  bool get isRead => readAt != null;
  bool get isUnread => readAt == null;
}

@JsonSerializable()
class UnreadCountResponse {
  @JsonKey(name: 'count')
  final int count;

  UnreadCountResponse({required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnreadCountResponseToJson(this);
} 