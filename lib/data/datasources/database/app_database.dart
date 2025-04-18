import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hocmoingay/data/datasources/database/dao/user_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_database.g.dart';

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn get grade => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD cho bảng users
  Future<List<UserEntity>> getAllUsers() => select(users).get();

  Future<void> insertUser(UserEntity user) => into(users).insert(user);

  Future<void> deleteUser(String id) => (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteAllUsers() => delete(users).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hocmoingay.db'));
    return NativeDatabase(file);
  });
}
