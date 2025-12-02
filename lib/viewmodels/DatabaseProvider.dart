import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

import '../models/database/Note.dart';
import '../models/database/Password.dart';

class DatabaseProvider with ChangeNotifier {
  String _databaseName = "safe_vault.db";
  Database? _db;

  String get databaseName => _databaseName;

  void setDatabaseName(String name) {
    _databaseName = name;
    notifyListeners();
  }

  /// Open the database with the given password.<br>
  /// @param password The password to open the database.<br>
  Future<void> openDatabaseWithPassword(String password) async {
    _db = await openDatabase(join(await getDatabasesPath(), _databaseName), password: password);
    notifyListeners();
  }

  /// Close the database.<br>
  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    notifyListeners();
  }

  /// Return true if the database exists.<br>
  Future<bool> doesExist() async {
    String path = await getDatabasesPath();
    if(await databaseExists(join(path,_databaseName))){
      return true;
    }
    else {
      return false;
    }
  }

  // ============== DATABASE INITIALIZATION ===============

  /// Initialize the database with the given password.<br>
  /// @param password The password to initialize the database.<br>
  Future<void> initializeDatabase(String password) async {
    _db ??= await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        version: 1,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        password: password
      );
    notifyListeners();
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Category(
        id_category INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Password(
        id_pwd INTEGER PRIMARY KEY AUTOINCREMENT,
        password TEXT NOT NULL,
        username TEXT NOT NULL,
        website TEXT,
        is_favorite INTEGER NOT NULL,
        id_category INTEGER,
        FOREIGN KEY (id_category) REFERENCES Category (id_category) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE Note(
        id_note INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date INTEGER NOT NULL
      );
    ''');

    // Insert the 4 default categories
    await insertCategories(db);

  }


  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }


  Future<void> insertCategories(Database db) async {
    await db.insert('Category', {
      'title': 'Sites Web'
    });
    await db.insert('Category', {
      'title': 'Réseaux Sociaux'
    });
    await db.insert('Category', {
      'title': 'Applications'
    });
    await db.insert('Category', {
      'title': 'Paiements'
    });
  }

  // =============== DATABASE OPERATIONS : CRUD ===============

  // =============== Password ===============

  /// Insert a new password into the database.<br>
  /// Returns the id of the inserted password.<br>
  /// @param pwd The password to insert.<br>
  Future<int> insertPassword(Password pwd) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.insert('Password', pwd.toMap());
    return result;
  }

  /// Retrieve all passwords from the database.<br>
  /// Returns a list of passwords.<br>
  Future<List<Password>> retrievePasswords() async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final List<Map<String, dynamic>> queryResult = await _db!.query('Password');
    final result = queryResult.map((e) => Password.fromMap(e)).toList();
    return result;
  }

  /// Update a password in the database.<br>
  /// Returns the number of rows affected.<br>
  /// @param pwd The password to update.<br>
  Future<int> updatePassword(Password pwd) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.update(
      'Password',
      pwd.toMap(),
      where: 'id_pwd = ?',
      whereArgs: [pwd.id_pwd],
    );
    return result;
  }


  /// Delete a password from the database.<br>
  /// Returns the number of rows affected.<br>
  /// @param id The id of the password to delete.<br>
  Future<int> deletePassword(int id) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.delete(
      'Password',
      where: 'id_pwd = ?',
      whereArgs: [id],
    );
    return result;
  }


  // =============== Note ===============

  /// Insert a new note into the database.<br>
  /// Returns the id of the inserted note.<br>
  /// @param note The note to insert.<br>
  Future<int> insertNote(Note note) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.insert('Note', note.toMap());
    return result;
  }


  /// Retrieve all notes from the database.<br>
  /// Returns a list of notes.<br>
  Future<List<Note>> retrieveNotes() async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final List<Map<String, dynamic>> queryResult = await _db!.query('Note');
    final result = queryResult.map((e) => Note.fromMap(e)).toList();
    return result;
  }

  /// Update a note in the database.<br>
  /// Returns the number of rows affected.<br>
  /// @param note The note to update.<br>
  Future<int> updateNote(Note note) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.update(
      'Note',
      note.toMap(),
      where: 'id_note = ?',
      whereArgs: [note.id_note],
    );
    return result;
  }


  /// Delete a note from the database.<br>
  /// Returns the number of rows affected.<br>
  /// @param id The id of the note to delete.<br>
  Future<int> deleteNote(int id) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.delete(
      'Note',
      where: 'id_note = ?',
      whereArgs: [id],
    );
    return result;
  }

}