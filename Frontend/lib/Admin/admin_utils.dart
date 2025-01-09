// Create a new file: lib/utils/admin_utils.dart

class AdminUtils {
  static bool isAdmin(String email) {
    return email.toLowerCase() == 'admin@gmail.com';
  }
}