import 'db_helper.dart';
import '../schemas/user.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  Future<bool> registerUser (User user) async {
    final db = await _dbHelper.database;
    try {
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      // Puede ser que el usuario ya exista
      return false;
    }
  }

  Future<User?> login(String username, String password) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}