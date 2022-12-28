import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> loginIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<void> sendEmailVerification();
}
