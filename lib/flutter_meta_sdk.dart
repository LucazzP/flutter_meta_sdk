import 'src/flutter_meta_sdk_platform_interface.dart';

class FlutterMetaSdk {
  // See: https://github.com/facebook/facebook-android-sdk/blob/master/facebook-core/src/main/java/com/facebook/appevents/AppEventsConstants.java
  static const eventNameCompletedRegistration =
      FlutterMetaSdkPlatform.eventNameCompletedRegistration;
  static const eventNameViewedContent = FlutterMetaSdkPlatform.eventNameViewedContent;
  static const eventNameRated = FlutterMetaSdkPlatform.eventNameRated;
  static const eventNameInitiatedCheckout = FlutterMetaSdkPlatform.eventNameInitiatedCheckout;
  static const eventNameAddedToCart = FlutterMetaSdkPlatform.eventNameAddedToCart;
  static const eventNameAddedToWishlist = FlutterMetaSdkPlatform.eventNameAddedToWishlist;
  static const eventNameSubscribe = FlutterMetaSdkPlatform.eventNameSubscribe;
  static const eventNameStartTrial = FlutterMetaSdkPlatform.eventNameStartTrial;
  static const eventNameAdImpression = FlutterMetaSdkPlatform.eventNameAdImpression;
  static const eventNameAdClick = FlutterMetaSdkPlatform.eventNameAdClick;

  static const paramNameAdType = FlutterMetaSdkPlatform.paramNameAdType;
  static const paramNameCurrency = FlutterMetaSdkPlatform.paramNameCurrency;
  static const paramNameOrderId = FlutterMetaSdkPlatform.paramNameOrderId;
  static const paramNameRegistrationMethod = FlutterMetaSdkPlatform.paramNameRegistrationMethod;
  static const paramNamePaymentInfoAvailable = FlutterMetaSdkPlatform.paramNamePaymentInfoAvailable;
  static const paramNameNumItems = FlutterMetaSdkPlatform.paramNameNumItems;
  static const paramValueYes = FlutterMetaSdkPlatform.paramValueYes;
  static const paramValueNo = FlutterMetaSdkPlatform.paramValueNo;

  /// Parameter key used to specify a generic content type/family for the logged event, e.g.
  /// "music", "photo", "video".  Options to use will vary depending on the nature of the app.
  static const paramNameContentType = FlutterMetaSdkPlatform.paramNameContentType;

  /// Parameter key used to specify data for the one or more pieces of content being logged about.
  /// Data should be a JSON encoded string.
  /// Example:
  ///   "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]"
  static const paramNameContent = FlutterMetaSdkPlatform.paramNameContent;

  /// Parameter key used to specify an ID for the specific piece of content being logged about.
  /// This could be an EAN, article identifier, etc., depending on the nature of the app.
  static const paramNameContentId = FlutterMetaSdkPlatform.paramNameContentId;

  Future<void> activateApp() {
    return FlutterMetaSdkPlatform.instance.activateApp();
  }

  /// Clears the current user data
  Future<void> clearUserData() {
    return FlutterMetaSdkPlatform.instance.clearUserData();
  }

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
  }) {
    return FlutterMetaSdkPlatform.instance.setUserData(
      externalUserId: externalUserId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      city: city,
      state: state,
      zip: zip,
      country: country,
    );
  }

  /// Clears the currently set user id.
  Future<void> clearUserID() {
    return FlutterMetaSdkPlatform.instance.clearUserID();
  }

  /// Explicitly flush any stored events to the server.
  Future<void> flush() {
    return FlutterMetaSdkPlatform.instance.flush();
  }

  /// Returns the app ID this logger was configured to log to.
  Future<String?> getApplicationId() {
    return FlutterMetaSdkPlatform.instance.getApplicationId();
  }

  /// Returns the current Facebook SDK version
  Future<String?> getSdkVersion() {
    return FlutterMetaSdkPlatform.instance.getSdkVersion();
  }

  Future<String?> getAnonymousId() {
    return FlutterMetaSdkPlatform.instance.getAnonymousId();
  }

  /// Log an app event with the specified [name] and the supplied [parameters] value.
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) {
    return FlutterMetaSdkPlatform.instance.logEvent(
      name: name,
      parameters: parameters,
      valueToSum: valueToSum,
    );
  }

  /// Logs an app event that tracks that the application was open via Push Notification.
  Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  }) {
    return FlutterMetaSdkPlatform.instance.logPushNotificationOpen(
      payload: payload,
      action: action,
    );
  }

  /// Sets a user [id] to associate with all app events.
  /// This can be used to associate your own user id with the
  /// app events logged from this instance of an application.
  /// The user ID will be persisted between application instances.
  Future<void> setUserID(String id) {
    return FlutterMetaSdkPlatform.instance.setUserID(id);
  }

  /// Log this event when the user has completed registration with the app.
  /// Parameter [registrationMethod] is used to specify the method the user has
  /// used to register for the app, e.g. "Facebook", "email", "Google", etc.
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnamecompletedregistration
  Future<void> logCompletedRegistration({String? registrationMethod}) {
    return FlutterMetaSdkPlatform.instance.logCompletedRegistration(
      registrationMethod: registrationMethod,
    );
  }

  /// Log this event when the user has rated an item in the app.
  ///
  /// See: https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/#eventnamerated
  Future<void> logRated({double? valueToSum}) {
    return FlutterMetaSdkPlatform.instance.logRated(valueToSum: valueToSum);
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
    return FlutterMetaSdkPlatform.instance.logViewContent(
      content: content,
      id: id,
      type: type,
      currency: currency,
      price: price,
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
    return FlutterMetaSdkPlatform.instance.logAddToCart(
      content: content,
      id: id,
      type: type,
      currency: currency,
      price: price,
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
    return FlutterMetaSdkPlatform.instance.logAddToWishlist(
      content: content,
      id: id,
      type: type,
      currency: currency,
      price: price,
    );
  }

  /// Re-enables auto logging of app events after user consent
  /// if disabled for GDPR-compliance.
  ///
  /// See: https://developers.facebook.com/docs/app-events/gdpr-compliance
  Future<void> setAutoLogAppEventsEnabled(bool enabled) {
    return FlutterMetaSdkPlatform.instance.setAutoLogAppEventsEnabled(enabled);
  }

  /// Set Data Processing Options
  /// This is needed for California Consumer Privacy Act (CCPA) compliance
  ///
  /// See: https://developers.facebook.com/docs/marketing-apis/data-processing-options
  Future<void> setDataProcessingOptions(
    List<String> options, {
    int? country,
    int? state,
  }) {
    return FlutterMetaSdkPlatform.instance.setDataProcessingOptions(
      options,
      country: country,
      state: state,
    );
  }

  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) {
    return FlutterMetaSdkPlatform.instance.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  Future<void> logInitiatedCheckout({
    double? totalPrice,
    String? currency,
    String? contentType,
    String? contentId,
    int? numItems,
    bool paymentInfoAvailable = false,
  }) {
    return FlutterMetaSdkPlatform.instance.logInitiatedCheckout(
      totalPrice: totalPrice,
      currency: currency,
      contentType: contentType,
      contentId: contentId,
      numItems: numItems,
      paymentInfoAvailable: paymentInfoAvailable,
    );
  }

  /// Sets the Advert Tracking propeety for iOS advert tracking
  /// an iOS 14+ feature, android should just return a success.
  Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) {
    return FlutterMetaSdkPlatform.instance.setAdvertiserTracking(
      enabled: enabled,
      collectId: collectId,
    );
  }

  /// The start of a paid subscription for a product or service you offer.
  /// See:
  ///   - https://developers.facebook.com/docs/marketing-api/app-event-api/
  ///   - https://developers.facebook.com/docs/reference/androidsdk/current/facebook/com/facebook/appevents/appeventsconstants.html/
  Future<void> logSubscribe({
    double? price,
    String? currency,
    required String orderId,
  }) {
    return FlutterMetaSdkPlatform.instance.logSubscribe(
      price: price,
      currency: currency,
      orderId: orderId,
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
    return FlutterMetaSdkPlatform.instance.logStartTrial(
      price: price,
      currency: currency,
      orderId: orderId,
    );
  }

  /// Log this event when the user views an ad.
  Future<void> logAdImpression({
    required String adType,
  }) {
    return FlutterMetaSdkPlatform.instance.logAdImpression(adType: adType);
  }

  /// Log this event when the user clicks an ad.
  Future<void> logAdClick({
    required String adType,
  }) {
    return FlutterMetaSdkPlatform.instance.logAdClick(adType: adType);
  }
}
