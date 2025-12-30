class AppConstants {
  static const String appName = 'Kochi Metro Supervisor';

  static const String baseUrl = 'https://kochi-metro-backend.onrender.com';

  static const String authTokenKey = 'auth_token';

  static const String userDataKey = 'user_data';

  // Animation durations

  static const Duration splashDuration = Duration(seconds: 3);

  static const Duration animationDuration = Duration(milliseconds: 300);

  // Error messages

  static const String networkErrorMessage = 'Network connection failed';

  static const String genericErrorMessage = 'Something went wrong';

  static const String invalidCredentialsMessage = 'Invalid credentials';
}
