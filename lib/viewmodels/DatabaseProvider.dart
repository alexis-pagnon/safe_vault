import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

import 'package:safe_vault/models/database/Note.dart';
import 'package:safe_vault/models/database/Password.dart';

class DatabaseProvider with ChangeNotifier {
  String _databaseName = "safe_vault.db";
  Database? _db;
  bool _isOpened = false;
  List<Password> _passwords = [];
  List<Note> _notes = [];
  int _passwordVersion = 0;
  int _noteVersion = 0;
  int _category = 0;
  String _query = '';
  List<int> _idsToFilter = [];
  int _noteCategory = 0;


  String get databaseName => _databaseName;
  bool get isOpened => _isOpened;
  List<Password> get passwords => _passwords;
  List<Note> get notes => _notes;


  List<Password> get favoritePasswords => _passwords.where((pwd) => pwd.is_favorite).toList();

  List<Password> get categoryWebPasswords => _passwords.where((pwd) => pwd.id_category == 1).toList();
  List<Password> get categorySocialPasswords => _passwords.where((pwd) => pwd.id_category == 2).toList();
  List<Password> get categoryAppPasswords => _passwords.where((pwd) => pwd.id_category == 3).toList();
  List<Password> get categoryPaymentPasswords => _passwords.where((pwd) => pwd.id_category == 4).toList();

  List<Password> get categoryFilteredPasswords => _passwords.where((pwd) => _idsToFilter.contains(pwd.id_pwd)).toList();

  List<Note> get normalNotes => _notes.where((note) => note.isTemporary == false).toList();
  List<Note> get temporaryNotes => _notes.where((note) => note.isTemporary == true).toList();

  int get passwordVersion => _passwordVersion;
  int get noteVersion => _noteVersion;




  Future<void> init(String key) async {
    await initializeDatabase(key);
    _isOpened = true;
    notifyListeners();
    await loadPasswords();

    // Delete temporary notes older than 7 days
    int dateMinus7Days = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    await deleteTemporaryNotes(dateMinus7Days);
    // No need to loadNotes here since it will be done by deleteTemporaryNotes
  }


  void setDatabaseName(String name) {
    _databaseName = name;
    notifyListeners();
  }

  /// Open the database with the given password.<br>
  /// @param password The password to open the database.<br>
  Future<void> openDatabaseWithPassword(String password) async {
    _db = await openDatabase(join(await getDatabasesPath(), _databaseName), password: password);
    _isOpened = true;
    notifyListeners();
  }

  /// Close the database.<br>
  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
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



  /// Load all passwords from the database into the provider's state.<br>
  Future<void> loadPasswords() async {
    _passwords = await retrievePasswords();
    _passwordVersion++;
    notifyListeners();
  }


  /// Load all notes from the database into the provider's state.<br>
  Future<void> loadNotes() async {
    _notes = await retrieveNotes();
    _noteVersion++;
    notifyListeners();
  }


  void setCategory(int category) {
    _category = category;
    notifyListeners();
  }

  void setNoteCategory(int category) {
    _noteCategory = category;
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void resetFilters() {
    _category = 0;
    _noteCategory = 0;
    _query = '';
    _idsToFilter = [];
    notifyListeners();
  }


  /// Set the list of IDs to filter passwords.<br>
  /// Use category 6 to apply this filter.<br>
  /// @param ids The list of IDs to filter passwords.<br>
  void setIdsToFilter(List<int> ids) {
    _category = 6;
    _idsToFilter = ids;
    notifyListeners();
  }


  /// Search passwords by service or website.<br>
  List<Password> searchPasswordsInList(List<Password> passwords, String query) {
    return passwords.where((pwd) =>
    pwd.service.toLowerCase().contains(query.toLowerCase()) ||
        pwd.website.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }


  /// Apply filter (and query) to passwords.<br>
  /// Returns the filtered list of passwords.<br>
  /// Filters : 
  /// - 0 = All,
  /// - 1 = Favorites,
  /// - 2 = Web,
  /// - 3 = Social,
  /// - 4 = App,
  /// - 5 = Payment,
  /// - 6 = Filtered by IDs.<br>
  /// - default = All.<br>
  List<Password> filteredPasswords() {
    List<Password> result = [];
    switch(_category) {
      case 0:
        if(_query.isNotEmpty) {
          result = searchPasswordsInList(_passwords, _query);
        }
        else {
          result = _passwords;
        }
        break;
      case 1:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(favoritePasswords, _query);
        }
        else {
          result =  favoritePasswords;
        }
        break;
      case 2:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(categoryWebPasswords, _query);
        }
        else {
          result =  categoryWebPasswords;
        }
        break;
      case 3:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(categorySocialPasswords, _query);
        }
        else {
          result =  categorySocialPasswords;
        }
        break;
      case 4:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(categoryAppPasswords, _query);
        }
        else {
          result =  categoryAppPasswords;
        }
        break;
      case 5:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(categoryPaymentPasswords, _query);
        }
        else {
          result =  categoryPaymentPasswords;
        }
        break;
      case 6:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(categoryFilteredPasswords, _query);
        }
        else {
          result =  categoryFilteredPasswords;
        }
        break;
      default:
        if(_query.isNotEmpty) {
          result =  searchPasswordsInList(_passwords, _query);
        }
        else {
          result =  _passwords;
        }
        break;
    }
    // favorites first
    result.sort((a, b) => a.service.toLowerCase().compareTo(b.service.toLowerCase()));
    return result;
  }


  /// Search notes.<br>
  /// Returns the filtered list of notes.<br>
  /// Filters are based on noteCategory (0= Normal, 1= Temporary) and query.<br>
  List<Note> searchNotes() {

    List<Note> filteredNotes = [];
    if(_noteCategory == 0) {
      filteredNotes = normalNotes;
    }
    else if(_noteCategory == 1) {
      filteredNotes = temporaryNotes;
    }
    else {
      filteredNotes = normalNotes;
    }

    filteredNotes.sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    if(_query.isEmpty) {
      return filteredNotes;
    }
    else {
      return filteredNotes.where((note) =>
      note.title.toLowerCase().contains(_query.toLowerCase())
      ).toList();
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
        service TEXT NOT NULL,
        website TEXT,
        is_favorite INTEGER NOT NULL,
        last_update INTEGER NOT NULL,
        id_category INTEGER,
        FOREIGN KEY (id_category) REFERENCES Category (id_category) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE Note(
        id_note INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date INTEGER NOT NULL,
        is_temporary INTEGER NOT NULL
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
      'id_category': 1,
      'title': 'Sites Web'
    });
    await db.insert('Category', {
      'id_category': 2,
      'title': 'Réseaux Sociaux'
    });
    await db.insert('Category', {
      'id_category': 3,
      'title': 'Applications'
    });
    await db.insert('Category', {
      'id_category': 4,
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
    await loadPasswords(); // refresh data
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


  /// Retrieve a password by its id from the database.<br>
  /// Returns the password.<br>
  /// @param id The id of the password to retrieve.<br>
  Future<Password?> retrievePasswordFromId(int id) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final List<Map<String, dynamic>> queryResult = await _db!.query(
      'Password',
      where: 'id_pwd = ?',
      whereArgs: [id],
    );
    if(queryResult.isEmpty) {
      return null;
    }
    final result = Password.fromMap(queryResult.first);
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
    await loadPasswords(); // refresh data
    return result;
  }


  /// Toggle the favorite status of a password in the database.<br>
  Future<int> toggleFavoriteStatus(int id, bool isFavorite) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.update(
      'Password',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id_pwd = ?',
      whereArgs: [id],
    );
    await loadPasswords();
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
    await loadPasswords(); // refresh data
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
    await loadNotes(); // refresh data
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
    await loadNotes(); // refresh data
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
    await loadNotes(); // refresh data
    return result;
  }


  /// Delete all temporary notes that precede a given date (in milliseconds since epoch) from the database.<br>
  /// @param dateLimit The date limit in milliseconds since epoch.<br>
  Future<int> deleteTemporaryNotes(int dateLimit) async {
    if(_db == null) {
      throw Exception("Database is not initialized");
    }
    final result = await _db!.delete(
      'Note',
      where: 'is_temporary = ? AND date < ?',
      whereArgs: [1, dateLimit],
    );
    await loadNotes(); // refresh data
    return result;
  }

}