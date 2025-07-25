import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_meta_sdk_method_channel.dart';

abstract class FlutterMetaSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterMetaSdkPlatform.
  FlutterMetaSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMetaSdkPlatform _instance = MethodChannelFlutterMetaSdk();

  /// The default instance of [FlutterMetaSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMetaSdk].
  static FlutterMetaSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMetaSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterMetaSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // See: https://github.com/facebook/facebook-android-sdk/blob/master/facebook-core/src/main/java/com/facebook/appevents/AppEventsConstants.java
  static const eventNameCompletedRegistration = 'fb_mobile_complete_registration';
  static const eventNameViewedContent = 'fb_mobile_content_view';
  static const eventNameRated = 'fb_mobile_rate';
  static const eventNameInitiatedCheckout = 'fb_mobile_initiated_checkout';
  static const eventNameAddedToCart = 'fb_mobile_add_to_cart';
  static const eventNameAddedToWishlist = 'fb_mobile_add_to_wishlist';
  static const eventNameSubscribe = "Subscribe";
  static const eventNameStartTrial = "StartTrial";
  static const eventNameAdImpression = "AdImpression";
  static const eventNameAdClick = "AdClick";

  static const paramNameAdType = "fb_ad_type";
  static const paramNameCurrency = "fb_currency";
  static const paramNameOrderId = "fb_order_id";
  static const paramNameRegistrationMethod = "fb_registration_method";
  static const paramNamePaymentInfoAvailable = "fb_payment_info_available";
  static const paramNameNumItems = "fb_num_items";
  static const paramValueYes = "1";
  static const paramValueNo = "0";

  /// Parameter key used to specify a generic content type/family for the logged event, e.g.
  /// "music", "photo", "video".  Options to use will vary depending on the nature of the app.
  static const paramNameContentType = "fb_content_type";

  /// Parameter key used to specify data for the one or more pieces of content being logged about.
  /// Data should be a JSON encoded string.
  /// Example:
  ///   "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]"
  static const paramNameContent = "fb_content";

  /// Parameter key used to specify an ID for the specific piece of content being logged about.
  /// This could be an EAN, article identifier, etc., depending on the nature of the app.
  static const paramNameContentId = "fb_content_id";

  Future<void> activateApp();

  /// Clears the current user data
  Future<void> clearUserData();

  /// Sets user data to associate with all app events.
  /// All user data are hashed and used to match Facebook user from this
  /// instance of an application. The user data will be persisted between
  /// application instances.
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
  });

  /// Clears the currently set user id.
  Future<void> clearUserID();

  /// Explicitly flush any stored events to the server.
  Future<void> flush();

  /// Returns the app ID this logger was configured to log to.
  Future<String?> getApplicationId();

  /// Returns the current Facebook SDK version
  Future<String?> getSdkVersion();

  Future<String?> getAnonymousId();

  /// Log an app event with the specified [name] and the supplied [parameters] value.
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  });

  /// Logs an app event that tracks that the application was open via Push Notification.
  Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  });

  /// Sets a user [id] to associate with all app events.
  /// This can be used to associate your own user id with the
  /// app events logged from this instance of an application.
  /// The user ID will be persisted between application instances.
  Future<void> setUserID(String id);

  /// Log this event when the user has completed registration with the app.
  /// Parameter [registrationMethod] is used to specify the method the user has
  /// used to register for the app, e.g. "Facebook", "email", "Google", etc.
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnamecompletedregistration
  Future<void> logCompletedRegistration({String? registrationMethod}) {
    return logEvent(
      name: eventNameCompletedRegistration,
      parameters: {
        paramNameRegistrationMethod: registrationMethod,
      },
    );
  }

  /// Log this event when the user has rated an item in the app.
  ///
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnamerated
  Future<void> logRated({double? valueToSum}) {
    return logEvent(
      name: eventNameRated,
      valueToSum: valueToSum,
    );
  }

  /// Log this event when the user has viewed a form of content in the app.
  ///
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnameviewedcontent
  Future<void> logViewContent({
    Map<String, dynamic>? content,
    String? id,
    String? type,
    String? currency,
    double? price,
  }) {
    return logEvent(
      name: eventNameViewedContent,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  /// Log this event when the user has added item to cart
  ///
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnameaddedtocart
  Future<void> logAddToCart({
    Map<String, dynamic>? content,
    required String id,
    required String type,
    required String currency,
    required double price,
  }) {
    return logEvent(
      name: eventNameAddedToCart,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  /// Log this event when the user has added item to cart
  ///
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnameaddedtowishlist
  Future<void> logAddToWishlist({
    Map<String, dynamic>? content,
    required String id,
    required String type,
    required String currency,
    required double price,
  }) {
    return logEvent(
      name: eventNameAddedToWishlist,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  /// Re-enables auto logging of app events after user consent
  /// if disabled for GDPR-compliance.
  ///
  /// See: https://developers.facebook.com/docs/app-events/gdpr-compliance
  Future<void> setAutoLogAppEventsEnabled(bool enabled);

  /// Set Data Processing Options
  /// This is needed for California Consumer Privacy Act (CCPA) compliance
  ///
  /// See: https://developers.facebook.com/docs/marketing-apis/data-processing-options
  Future<void> setDataProcessingOptions(
    List<String> options, {
    int? country,
    int? state,
  });

  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  });

  Future<void> logInitiatedCheckout({
    double? totalPrice,
    String? currency,
    String? contentType,
    String? contentId,
    int? numItems,
    bool paymentInfoAvailable = false,
  }) {
    return logEvent(
      name: eventNameInitiatedCheckout,
      valueToSum: totalPrice,
      parameters: {
        paramNameContentType: contentType,
        paramNameContentId: contentId,
        paramNameNumItems: numItems,
        paramNameCurrency: currency,
        paramNamePaymentInfoAvailable: paymentInfoAvailable ? paramValueYes : paramValueNo,
      },
    );
  }

  /// Sets the Advert Tracking propeety for iOS advert tracking
  /// an iOS 14+ feature, android should just return a success.
  Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  });

  /// The start of a paid subscription for a product or service you offer.
  /// See:
  ///   - https://developers.facebook.com/docs/marketing-api/app-event-api/
  ///   - https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/
  Future<void> logSubscribe({
    double? price,
    String? currency,
    required String orderId,
  }) {
    return logEvent(
      name: eventNameSubscribe,
      valueToSum: price,
      parameters: {
        paramNameCurrency: currency,
        paramNameOrderId: orderId,
      },
    );
  }

  /// The start of a free trial of a product or service you offer (example: trial subscription).
  /// See:
  ///   - https://developers.facebook.com/docs/marketing-api/app-event-api/
  ///   - https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/
  Future<void> logStartTrial({
    double? price,
    String? currency,
    required String orderId,
  }) {
    return logEvent(
      name: eventNameStartTrial,
      valueToSum: price,
      parameters: {
        paramNameCurrency: currency,
        paramNameOrderId: orderId,
      },
    );
  }

  /// Log this event when the user views an ad.
  Future<void> logAdImpression({
    required String adType,
  }) {
    return logEvent(
      name: eventNameAdImpression,
      parameters: {
        paramNameAdType: adType,
      },
    );
  }

  /// Log this event when the user clicks an ad.
  Future<void> logAdClick({
    required String adType,
  }) {
    return logEvent(
      name: eventNameAdClick,
      parameters: {
        paramNameAdType: adType,
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  //
  // PRIVATE METHODS BELOW HERE
  
  /// Creates a new map containing all of the key/value pairs from [parameters]
  /// except those whose value is `null`.
  @nonVirtual
  Map<String, dynamic> filterOutNulls(Map<String, dynamic> parameters) {
    final Map<String, dynamic> filtered = <String, dynamic>{};
    parameters.forEach((String key, dynamic value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}
