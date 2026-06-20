/// Simple in-memory key/value store.
///
/// Replaces the previous `shared_preferences`-backed implementation. Values
/// live only for the duration of the app session and are not persisted to disk.
class Prefs {
  static const String apiToken = 'apiToken';
  static const String authStatus = 'authStatus';
  static const String userName = 'userName';
  static const String userEmail = 'userEmail';
  static const String userMobileNo = 'userMobileNo';
  static const String userId = 'userId';
  static const String walletId = 'walletId';
  static const String cartItems = 'cartItems';
  static const String coupon = 'coupon';
  static const String onboarding = 'onboarding';

  static const String appVersion = 'appVersion';
  static const String deviceOS = 'deviceOS';
  static const String userData = 'userData';
  static const String isDeveloperMode = 'developerMode';
  static const String isHomeOffer = 'isHomeOffer';

  final Map<String, Object?> _store = {};

  // Save a data
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  // Get the stored data
  Future<String?> getString(String key) async {
    return _store[key] as String?;
  }

  // Save a data
  Future<void> setStringList(String key, List<String> value) async {
    _store[key] = value;
  }

  // Get the stored data
  Future<List<String>?> getStringList(String key) async {
    return _store[key] as List<String>?;
  }

  // save bool data
  Future<void> setBool(String key, bool value) async {
    _store[key] = value;
  }

  // get bool data
  Future<bool?> getBool(String key) async {
    return _store[key] as bool?;
  }

  // Add this method
  Future<void> remove(String key) async {
    _store.remove(key);
  }
}
