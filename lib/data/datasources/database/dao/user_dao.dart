import 'package:drift/drift.dart';
import '../app_database.dart';
part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<List<UserEntity>> getAllUsers() => select(users).get();

  Stream<List<UserEntity>> watchAllUsers() => select(users).watch();

  Future<UserEntity?> getUserById(String id) =>
      (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<void> insertUser(UserEntity user) =>
      into(users).insertOnConflictUpdate(user);

  Future<void> deleteUser(String id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteAllUsers() => delete(users).go();
}
