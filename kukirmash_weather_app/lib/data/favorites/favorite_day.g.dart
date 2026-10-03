// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteDay _$FavoriteDayFromJson(Map<String, dynamic> json) => FavoriteDay(
  id: json['id'] as String,
  condition: json['condition'] as String,
  temperatureMax: (json['temperatureMax'] as num).toDouble(),
  temperatureMin: (json['temperatureMin'] as num).toDouble(),
  addedAt: DateTime.parse(json['addedAt'] as String),
);

Map<String, dynamic> _$FavoriteDayToJson(FavoriteDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'condition': instance.condition,
      'temperatureMax': instance.temperatureMax,
      'temperatureMin': instance.temperatureMin,
      'addedAt': instance.addedAt.toIso8601String(),
    };
