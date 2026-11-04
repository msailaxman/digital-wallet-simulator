import '../models/user_model.dart';

// ==============================================================================
// EXPERIMENT 1 & 7: AUTHENTICATION SERVICE (SIMULATED LOCAL AUTH)
// Provides sample credentials and simple authentication logic for demonstration.
// NOTE FOR LAB EXAMINATION:
// This is simulated local authentication designed for student lab demonstration.
// No sensitive credentials or remote production tokens are handled.
// ==============================================================================

class AuthService {
  // Singleton pattern for accessible shared auth state
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Demo predefined credentials for viva examination
  static const String demoEmail = 'student@btech.ac.in';
  static const String demoPhone = '9876543210';
  static const String demoPassword = 'password123';

  bool _isLoggedIn = false;
  UserModel? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;

  /// Simulates user login
  bool login(String emailOrPhone, String password) {
    final cleanInput = emailOrPhone.trim().toLowerCase();
    final cleanPassword = password.trim();

    // Check against demo credentials or allow any valid populated credentials for testing
    if ((cleanInput == demoEmail || cleanInput == demoPhone) &&
        cleanPassword == demoPassword) {
      _isLoggedIn = true;
      _currentUser = UserModel(
        name: 'Aarav Patel',
        email: demoEmail,
        phoneNumber: demoPhone,
        walletId: 'DW-882190',
        bio: 'B.Tech CSE Student | Flutter Lab Manual Project',
      );
      return true;
    }

    // Also accept any non-empty password of 6+ chars for flexible demonstration
    if (cleanInput.isNotEmpty && cleanPassword.length >= 6) {
      _isLoggedIn = true;
      _currentUser = UserModel(
        name: cleanInput.contains('@') ? cleanInput.split('@')[0] : 'Demo User',
        email: cleanInput.contains('@') ? cleanInput : '$cleanInput@student.ac.in',
        phoneNumber: cleanInput.contains('@') ? '9876543210' : cleanInput,
        walletId: 'DW-991204',
        bio: 'B.Tech CSE Student | Flutter Lab Manual Project',
      );
      return true;
    }

    return false;
  }

  /// Simulates new user registration
  bool register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        phone.trim().isEmpty ||
        password.length < 6) {
      return false;
    }

    _isLoggedIn = true;
    _currentUser = UserModel(
      name: name.trim(),
      email: email.trim(),
      phoneNumber: phone.trim(),
      walletId: 'DW-${DateTime.now().millisecondsSinceEpoch % 1000000}',
      bio: 'B.Tech CSE Student | Flutter Lab Manual Project',
    );
    return true;
  }

  /// Logs the user out
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }
}
