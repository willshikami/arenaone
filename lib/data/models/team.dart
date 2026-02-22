import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  final String id;
  final String name;
  final String sport;
  final String? logoUrl;
  final bool isFollowing;

  Team({
    required this.id,
    required this.name,
    required this.sport,
    this.logoUrl,
    this.isFollowing = false,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);

  Team copyWith({
    String? id,
    String? name,
    String? sport,
    String? logoUrl,
    bool? isFollowing,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      logoUrl: logoUrl ?? this.logoUrl,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
