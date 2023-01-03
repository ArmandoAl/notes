import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("mock auth", () {
    final provider = MockAuthProvider();
    test("should not initialize", () {
      expect(provider.isInitialize, false);
    });

    test("cannot log out if not initialize", () {
      expect(provider.signOut(),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });

    test("Should be able to be initiaized", () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    });

    test("Should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test("Should be able to initialize in less than 2 seconds", () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should delegate to longin", () async {
      final badEmailUser =
          provider.signUp(email: "foo@bar.com", password: "123456");
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFooundAuthException>()));

      final badPasswordUser = provider.signUp(
        email: "someone@bar.com",
        password: "foobar",
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.signUp(email: "foo", password: "bar");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logget in user should be able to get verified", () async {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should to be able to log out and log in again", () async {
      await provider.signOut();
      await provider.loginIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialize = false;
  bool get isInitialize => _isInitialize;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialize = true;
  }

  @override
  Future<AuthUser> loginIn(
      {required String email, required String password}) async {
    if (!_isInitialize) throw NotInitializeException();
    if (email == "foo@bar.com") throw UserNotFooundAuthException();
    if (password == "123456") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: '');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialize) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFooundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: '');
    _user = newUser;
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    if (!_isInitialize) throw NotInitializeException();
    if (_user == null) throw UserNotFooundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> signUp(
      {required String email, required String password}) async {
    if (!_isInitialize) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return loginIn(email: email, password: password);
  }
}
