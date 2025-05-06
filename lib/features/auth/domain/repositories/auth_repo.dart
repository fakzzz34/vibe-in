import 'package:vibe_in/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String username,
    String password,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
