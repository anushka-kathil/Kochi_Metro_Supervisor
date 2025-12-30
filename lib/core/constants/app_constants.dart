/// Centralized application-wide constants
/// Helps maintain consistency and avoid hard-coded values
class AppConstants {
  // App Info
  static const String appName = 'Kochi Metro Supervisor';

  // API Configuration
  static const String baseUrl = 'https://kochi-metro-backend.onrender.com';

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
