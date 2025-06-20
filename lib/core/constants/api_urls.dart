/// A collection of API URLs and base URLs used throughout the application.
class ApiUrls {
  // Base URLs
  static const String baseUrlDev = 'https://api.dev.example.com';
  static const String baseUrlProd = 'https://api.prod.example.com';
  static const String baseUrlStaging = 'https://api.staging.example.com';

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Audio Endpoints
  static const String createAudio = '/audio/create';
  static const String recordAudio = '/audio/record';
  static const String editAudio = '/audio/edit';
  static const String getAudioLibrary = '/audio/library';
  static const String getProjectTemplates = '/audio/templates';
}