// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCacheImpl _$$UserCacheImplFromJson(Map<String, dynamic> json) =>
    _$UserCacheImpl(
      userId: json['userId'] as String,
      host: json['host'] as String,
      users: (json['users'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UserLite.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$UserCacheImplToJson(_$UserCacheImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'host': instance.host,
      'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
    };
