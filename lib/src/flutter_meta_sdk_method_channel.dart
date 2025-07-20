import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_meta_sdk_platform_interface.dart';

/// An implementation of [FlutterMetaSdkPlatform] that uses method channels.
class MethodChannelFlutterMetaSdk extends FlutterMetaSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('solusibejo.com/flutter_meta_sdk');

  @override
  Future<void> activateApp() {
    return methodChannel.invokeMethod<void>('activateApp');
  }

  @override
  Future<void> clearUserData() {
    return methodChannel.invokeMethod<void>('clearUserData');
  }

  @override
  Future<void> setUserData({
    String? externalUserId,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final args = <String, dynamic>{
      'externalUserId': externalUserId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };

    return methodChannel.invokeMethod<void>('setUserData', args);
  }

  @override
  Future<void> clearUserID() {
    return methodChannel.invokeMethod<void>('clearUserID');
  }

  @override
  Future<void> flush() {
    return methodChannel.invokeMethod<void>('flush');
  }

  @override
  Future<String?> getApplicationId() {
    return methodChannel.invokeMethod<String>('getApplicationId');
  }

  @override
  Future<String?> getSdkVersion() {
    return methodChannel.invokeMethod<String>('getSdkVersion');
  }

  @override
  Future<String?> getAnonymousId() {
    return methodChannel.invokeMethod<String>('getAnonymousId');
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) {
    final args = <String, dynamic>{
      'name': name,
      '_valueToSum': valueToSum,
    };

    if (parameters != null) {
      args['parameters'] = filterOutNulls(parameters);
    }

    return methodChannel.invokeMethod<void>('logEvent', filterOutNulls(args));
  }

  @override
  Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  }) {
    final args = <String, dynamic>{
      'payload': payload,
      'action': action,
    };

    return methodChannel.invokeMethod<void>('logPushNotificationOpen', args);
  }

  @override
  Future<void> setUserID(String id) {
    return methodChannel.invokeMethod<void>('setUserID', id);
  }

  @override
  Future<void> setAutoLogAppEventsEnabled(bool enabled) {
    return methodChannel.invokeMethod<void>('setAutoLogAppEventsEnabled', enabled);
  }

  @override
  Future<void> setDataProcessingOptions(
    List<String> options, {
    int? country,
    int? state,
  }) {
    final args = <String, dynamic>{
      'options': options,
      'country': country,
      'state': state,
    };

    return methodChannel.invokeMethod<void>('setDataProcessingOptions', args);
  }

  @override
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) {
    final args = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'parameters': parameters,
    };
    return methodChannel.invokeMethod<void>('logPurchase', filterOutNulls(args));
  }

  @override
  Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) {
    final args = <String, dynamic>{
      'enabled': enabled,
      'collectId': collectId,
    };

    return methodChannel.invokeMethod<void>('setAdvertiserTracking', args);
  }
}
