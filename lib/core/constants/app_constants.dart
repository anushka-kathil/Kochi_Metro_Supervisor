class AppConstants {
  // App Info
  static const String appName = 'Kochi Metro Supervisor';

  // API Configuration
  static const String baseUrl = 'https://kochi-metro-backend.onrender.com';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/user/profile';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Error Messages
  static const String networkErrorMessage = 'Network connection failed';
  static const String genericErrorMessage = 'Something went wrong';
  static const String invalidCredentialsMessage = 'Invalid credentials';
}
