import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';
import '../schemas/user.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  Future<bool> registerUser(User user) async {
  try {
    final db = await _dbHelper.database;

    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    if (existing.isNotEmpty) {
      print("Usuario ya existe: ${user.username}");
      return false; 
    }

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort, 
    );

    print(" Usuario registrado: ${user.username}");
    return true;
  } catch (e) {
    print(" Error en registerUser: $e");
    return false;
  }
}


  Future<User?> login(String username, String password) async {
    try {
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
    } catch (e) {
      print("Error en login: $e");
      return null;
    }
  }
}
