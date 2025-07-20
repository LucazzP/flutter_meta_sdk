// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_meta_sdk_platform_interface.dart';

// JavaScript interop definitions
@JS('fbq')
external void _fbq(String action, String event, [JSAny? parameters]);

@JS('fbq')
external void _fbqDataProcessingOptions(String action, JSAny options,
    [JSAny? country, JSAny? state]);

@JS('window.fbq')
external JSFunction? get _fbqFunction;

// Helper to convert Dart maps to JavaScript objects
JSObject _mapToJSObject(Map<String, dynamic> map) {
  return map.jsify() as JSObject;
}

/// A web implementation of the FlutterMetaSdkPlatform of the FlutterMetaSdk plugin.
class FlutterMetaSdkWeb extends FlutterMetaSdkPlatform {
  /// Constructs a FlutterMetaSdkWeb
  FlutterMetaSdkWeb();

  static void registerWith(Registrar registrar) {
    FlutterMetaSdkPlatform.instance = FlutterMetaSdkWeb();
  }

  /// Helper method to check if fbq is available
  bool get _isFbqAvailable {
    try {
      return _fbqFunction != null;
    } catch (e) {
      throw Exception('fbq is not available. Make sure Meta Pixel is loaded in your index.html');
    }
  }

  /// Helper method to call fbq function safely
  void _callFbq(String action, String event, [Map<String, dynamic>? parameters]) {
    if (!_isFbqAvailable) {
      return;
    }

    try {
      // Merge stored user data with event parameters for advanced matching
      final mergedParams = <String, dynamic>{};
      if (_storedUserData.isNotEmpty) {
        mergedParams.addAll(_storedUserData);
      }
      if (parameters != null) {
        mergedParams.addAll(parameters);
      }

      if (mergedParams.isNotEmpty) {
        // Convert Dart Map to JavaScript object
        final jsParams = _mapToJSObject(mergedParams);
        _fbq(action, event, jsParams);
      } else {
        _fbq(action, event);
      }
    } catch (e) {
      print('Error calling fbq: $e');
    }
  }

  @override
  Future<void> activateApp() async {
    // Track PageView when app is activated
    _callFbq('track', 'PageView');
  }

  @override
  Future<void> clearUserData() async {
    // Web implementation - Meta Pixel doesn't have a direct clear user data method
    // You might want to clear any locally stored user data if you're maintaining any
    _storedUserData.clear();
  }

  // Store user data for advanced matching in subsequent events
  Map<String, dynamic> _storedUserData = {};

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
  }) async {
    if (!_isFbqAvailable) return;

    // Build user data object for advanced matching, removing null values
    final userData = <String, dynamic>{};
    if (externalUserId != null) userData['external_id'] = externalUserId;
    if (email != null) userData['em'] = email;
    if (firstName != null) userData['fn'] = firstName;
    if (lastName != null) userData['ln'] = lastName;
    if (phone != null) userData['ph'] = phone;
    if (dateOfBirth != null) userData['db'] = dateOfBirth;
    if (gender != null) userData['ge'] = gender;
    if (city != null) userData['ct'] = city;
    if (state != null) userData['st'] = state;
    if (zip != null) userData['zp'] = zip;
    if (country != null) userData['country'] = country;

    // Store user data for use in subsequent events (advanced matching)
    _storedUserData = {..._storedUserData, ...userData};

    // Note: Meta Pixel web uses advanced matching by including user data in events
    // rather than setting it globally like mobile SDKs
  }

  @override
  Future<void> clearUserID() async {
    // Meta Pixel web doesn't have a direct clearUserID method
    _storedUserData.remove('external_id');
  }

  @override
  Future<void> flush() async {
    // Meta Pixel web automatically sends events, no manual flush needed
  }

  @override
  Future<String?> getApplicationId() async {
    // Try to get the pixel ID from the fbq instance if possible
    if (_isFbqAvailable) {
      try {
        // This might not work depending on Meta Pixel implementation
        // Pixel ID is not easily accessible from the client side
        return null;
      } catch (e) {
        // Pixel ID is not easily accessible from the client side
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> getSdkVersion() async {
    // Web implementation - return web SDK version
    return '1.0.0-web';
  }

  @override
  Future<String?> getAnonymousId() async {
    // Meta Pixel manages its own anonymous tracking
    // This information is not typically accessible from client-side code
    return null;
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) async {
    // Standard events (predefined by Meta)
    final standardEvents = {
      'AddPaymentInfo',
      'AddToCart',
      'AddToWishlist',
      'CompleteRegistration',
      'Contact',
      'CustomizeProduct',
      'Donate',
      'FindLocation',
      'InitiateCheckout',
      'Lead',
      'Purchase',
      'Schedule',
      'Search',
      'StartTrial',
      'SubmitApplication',
      'Subscribe',
      'ViewContent'
    };

    final eventParams = <String, dynamic>{};
    if (parameters != null) {
      eventParams.addAll(parameters);
    }
    if (valueToSum != null) {
      eventParams['value'] = valueToSum;
    }

    if (standardEvents.contains(name)) {
      // Use 'track' for standard events
      _callFbq('track', name, eventParams.isNotEmpty ? eventParams : null);
    } else {
      // Use 'trackCustom' for custom events
      _callFbq('trackCustom', name, eventParams.isNotEmpty ? eventParams : null);
    }
  }

  @override
  Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  }) async {
    // Web doesn't typically handle push notifications the same way
    // You could track this as a custom event instead
    final params = Map<String, dynamic>.from(payload);
    if (action != null) {
      params['action'] = action;
    }
    _callFbq('trackCustom', 'PushNotificationOpen', params);
  }

  @override
  Future<void> setUserID(String id) async {
    // Meta Pixel doesn't have a direct setUserID method
    // But you can include user_id in event parameters or use advanced matching
    setUserData(externalUserId: id);
  }

  @override
  Future<void> setAutoLogAppEventsEnabled(bool enabled) async {
    // Meta Pixel web SDK doesn't have auto-logging control in the same way
    // Auto-logging is typically configured when initializing the pixel
  }

  @override
  Future<void> setDataProcessingOptions(
    List<String> options, {
    int? country,
    int? state,
  }) async {
    if (!_isFbqAvailable) return;

    try {
      // Convert options list to JavaScript array
      final jsOptions = options.jsify() as JSAny;
      final jsCountry = (country ?? 0).toJS;
      final jsState = (state ?? 0).toJS;

      // Facebook Pixel API: fbq('dataProcessingOptions', [''], country, state)
      _fbqDataProcessingOptions('dataProcessingOptions', jsOptions, jsCountry, jsState);
    } catch (e) {
      print('Error setting data processing options: $e');
    }
  }

  @override
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    final purchaseParams = <String, dynamic>{
      'value': amount,
      'currency': currency,
    };

    if (parameters != null) {
      purchaseParams.addAll(parameters);
    }

    _callFbq('track', 'Purchase', purchaseParams);
  }

  @override
  Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) async {
    // Web tracking is typically controlled through cookie consent
    // and privacy settings rather than this method
  }
}
