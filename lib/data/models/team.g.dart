// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
  id: json['id'] as String,
  name: json['name'] as String,
  sport: json['sport'] as String,
  logoUrl: json['logoUrl'] as String?,
  isFollowing: json['isFollowing'] as bool? ?? false,
);

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sport': instance.sport,
  'logoUrl': instance.logoUrl,
  'isFollowing': instance.isFollowing,
};
