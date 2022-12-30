import 'package:mynotes/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider _authProvider;
  AuthService(this._authProvider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => _authProvider.currentUser;

  @override
  Future<AuthUser> loginIn({
    required String email,
    required String password,
  }) async {
    return _authProvider.loginIn(email: email, password: password);
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    return _authProvider.signUp(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() {
    return _authProvider.sendEmailVerification();
  }

  @override
  Future<void> signOut() {
    return _authProvider.signOut();
  }

  @override
  Future<void> initialize() => _authProvider.initialize();
}
