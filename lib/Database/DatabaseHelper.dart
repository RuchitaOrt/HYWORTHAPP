import 'dart:async';
import 'package:hyworth_land_survey/Utils/GlobalLists.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('survey.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<Object?>? args]) async {
    final db = await instance.database;
    return await db.rawQuery(sql, args);
  }

  Future _createDB(Database db, int version) async {
    // await db.execute('DROP TABLE IF EXISTS surveys');
    await db.execute('''
      CREATE TABLE surveys (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surveyId TEXT,
        userId TEXT,
        solarParkACCapacity TEXT,
        solarParkDCCapacity TEXT,
        gridConnectivity TEXT,
        landLocation TEXT,
        landDHQ TEXT,
        landState TEXT,
        landDistrict TEXT,
        landTaluka TEXT,
        landVillage TEXT,
        landLatitude REAL,
        landLongitude REAL,
        landAreaInAcres TEXT,
        landType TEXT,
        landRateCommercialEscalation TEXT,
        subStationName TEXT,
        subStationDistrict TEXT,
        subStationTaluka TEXT,
        subStationVillage TEXT,
        subStationLatitude REAL,
        subStationLongitude REAL,
        subStationInchargeContact TEXT,
        inchargeName TEXT,
        operatorName TEXT,
        operatorContact TEXT,
        subStationVoltageLevel TEXT,
        subStationCapacity TEXT,
        distanceSubStationToLand TEXT,
        plotDistanceFromMainRoad TEXT,
        evacuationLevel TEXT,
        soilType TEXT,
        windZone TEXT,
        groundWaterRainFall TEXT,
        nearestHighway TEXT,
        consentAvailable INTEGER,
        isSync INTEGER,
        isSurveyapproved INTEGER,
        selectedLanguage TEXT,
        landPictures TEXT,  -- stored as JSON string
        surveyForms TEXT,    -- stored as JSON string
        consentForms TEXT,
        surveyDate INTEGER,
        updatedsurveyDate INTEGER,
        surveyStatus String,
        landDistrictID TEXT,
        landTalukaID TEXT,
        landVillageID TEXT,
        substationDistrictID TEXT,
        substationTalukaID TEXT,
        substationVillageID TEXT
      )
    ''');


    await db.execute('''
      CREATE TABLE district(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Taluka table (independent)
  await db.execute('''
    CREATE TABLE taluka(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''');

  // Village table (independent)
  await db.execute('''
    CREATE TABLE village(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''');

  await db.execute('''CREATE TABLE IF NOT EXISTS survey_sequence (
  yearMonth INTEGER PRIMARY KEY,
  lastSeq INTEGER
);
''');

  // Insert static Districts
  await db.insert('district', {'id': '1', 'name': 'Mumbai'});
  await db.insert('district', {'id': '2', 'name': 'Pune'});
  await db.insert('district', {'id': '3', 'name': 'Nagpur'});
  await db.insert('district', {'id': '4', 'name': 'Nashik'});
  await db.insert('district', {'id': '5', 'name': 'Thane'});
  await db.insert('district', {'id': '6', 'name': 'Kolhapur'});
  await db.insert('district', {'id': '7', 'name': 'Aurangabad'});
  await db.insert('district', {'id': '8', 'name': 'Solapur'});
  await db.insert('district', {'id': '9', 'name': 'Satara'});
  await db.insert('district', {'id': '10', 'name': 'Jalgaon'});

  // Insert static Talukas (10 entries)
  await db.insert('taluka', {'id': '1', 'name': 'Andheri'});
  await db.insert('taluka', {'id': '2', 'name': 'Bandra'});
  await db.insert('taluka', {'id': '3', 'name': 'Haveli'});
  await db.insert('taluka', {'id': '4', 'name': 'Mulshi'});
  await db.insert('taluka', {'id': '5', 'name': 'Nagpur Rural'});
  await db.insert('taluka', {'id': '6', 'name': 'Nashik East'});
  await db.insert('taluka', {'id': '7', 'name': 'Thane West'});
  await db.insert('taluka', {'id': '8', 'name': 'Kolhapur North'});
  await db.insert('taluka', {'id': '9', 'name': 'Aurangabad Central'});
  await db.insert('taluka', {'id': '10', 'name': 'Solapur South'});

  // Insert static Villages (10 entries)
  await db.insert('village', {'id': '1', 'name': 'Village A'});
  await db.insert('village', {'id': '2', 'name': 'Village B'});
  await db.insert('village', {'id': '3', 'name': 'Village C'});
  await db.insert('village', {'id': '4', 'name': 'Village D'});
  await db.insert('village', {'id': '5', 'name': 'Village E'});
  await db.insert('village', {'id': '6', 'name': 'Village F'});
  await db.insert('village', {'id': '7', 'name': 'Village G'});
  await db.insert('village', {'id': '8', 'name': 'Village H'});
  await db.insert('village', {'id': '9', 'name': 'Village I'});
  await db.insert('village', {'id': '10', 'name': 'Village J'});
  }
Future<List<Map<String, dynamic>>> getAllDistricts() async {
    final db = await instance.database;
    return await db.query('district');
  }
Future<List<Map<String, dynamic>>> getAllTalukas() async {
  final db = await DatabaseHelper.instance.database;
  return await db.query('taluka');
}
Future<List<Map<String, dynamic>>> getAllVillages() async {
  final db = await DatabaseHelper.instance.database;
  return await db.query('village');
}

  Future<void> deleteOldDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'survey.db');
    await deleteDatabase(path);
    print("✅ Old database deleted");
  }

  // Insert
  Future<int> insertSurvey(SurveyModel survey) async {
    final db = await instance.database;
    return await db.insert('surveys', survey.toJsonDB());
  }

//update
Future<int> updateSurvey(SurveyModel survey, int surveyID) async {
  final db = await instance.database;
  print("UPDATED SURVEY ID: $surveyID");

  // Remove null fields or id from the map
  final map = survey.toJsonDB();
  map.remove('id'); // ❌ do NOT update primary key

  // Replace any null with default values to avoid datatype mismatch
  map.updateAll((key, value) {
    if (value == null) {
      if (key.contains('Latitude') || key.contains('Longitude')) return 0.0;
      if (key.contains('Capacity') || key.contains('AC') || key.contains('DC')) return 0;
      if (key == 'consentAvailable' || key == 'isSurveyapproved') return 0;
      return ''; // default for strings
    }
    return value;
  });

  return await db.update(
    'surveys',
    map,
    where: 'id = ?',
    whereArgs: [surveyID],
  );
}

  // Fetch all
  Future<List<SurveyModel>> getAllSurveys() async {
    final db = await instance.database;
    final result = await db.query('surveys');
    print("TOTAL SURVEY ${result.length}");
    return result.map((json) => SurveyModel.fromJsonDB(json)).toList();
  }

  Future<List<SurveyModel>> getPendingSurveys() async {
  final db = await instance.database;
  final result = await db.query(
    'surveys',
    where: 'surveyStatus = ?',
    whereArgs: ["pending"],
  );
  print("TOTAL PENDING SURVEY ${result.length}");
  return result.map((json) => SurveyModel.fromJsonDB(json)).toList();
}
  Future<List<SurveyModel>> getConsentSurveys() async {
  final db = await instance.database;
  final result = await db.query(
    'surveys',
    where: 'consentAvailable = ?',
    whereArgs: ["1"],
  );
  print("TOTAL PENDING SURVEY ${result.length}");
  return result.map((json) => SurveyModel.fromJsonDB(json)).toList();
}
  Future<List<SurveyModel>> getCompletedSurveys() async {
  final db = await instance.database;
  final result = await db.query(
    'surveys',
    where: 'isSurveyapproved = ?',
    whereArgs: [1],
  );
  print("TOTAL PENDING SURVEY ${result.length}");
  return result.map((json) => SurveyModel.fromJsonDB(json)).toList();
}
Future<int> getApprovedSurveyCount() async {
  final db = await instance.database;
  final result = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 1'),
  );
  return result ?? 0;
}

Future<int> getConsentAvailableCount() async {
  final db = await instance.database;
  final result = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM surveys WHERE consentAvailable = 1'),
  );
  return result ?? 0;
}
Future<Map<String, dynamic>> getAllSurveysWithCounts({
  int? month,
  int? year,
}) async {
  final db = await instance.database;

  String whereClause = '';
  List<String> whereArgs = [];

  if (month != null && year != null) {
    whereClause =
        "strftime('%m', datetime(surveyDate / 1000, 'unixepoch')) = ? AND strftime('%Y', datetime(surveyDate / 1000, 'unixepoch')) = ?";
    whereArgs = [
      month.toString().padLeft(2, '0'),
      year.toString(),
    ];
  }

  // ✅ Total count
  final totalSurvey = Sqflite.firstIntValue(
    await db.rawQuery(
      'SELECT COUNT(*) FROM surveys ${whereClause.isNotEmpty ? "WHERE $whereClause" : ""}',
      whereArgs,
    ),
  ) ?? 0;

  // ✅ Approved
  final approvedCount = Sqflite.firstIntValue(
    await db.rawQuery(
      'SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 1 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
      whereArgs,
    ),
  ) ?? 0;

  // ✅ Pending
  final pendingCount = Sqflite.firstIntValue(
    await db.rawQuery(
      'SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 0 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
      whereArgs,
    ),
  ) ?? 0;

  // ✅ Consent
  final consentCount = Sqflite.firstIntValue(
    await db.rawQuery(
      'SELECT COUNT(*) FROM surveys WHERE consentAvailable = 1 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
      whereArgs,
    ),
  ) ?? 0;

  // ✅ Update global
  GlobalLists.totalSurvey = totalSurvey.toString();
  GlobalLists.approvedSurvey = approvedCount.toString();
  GlobalLists.consentSurvey = consentCount.toString();
  GlobalLists.pendingSurvey = pendingCount.toString();

  return {
    "surveys": totalSurvey,
    "approvedCount": approvedCount,
    "consentCount": consentCount,
    "pendingCount": pendingCount,
  };
}

// Future<Map<String, dynamic>> getAllSurveysWithCounts() async {
//   final db = await instance.database;

//   final result = await db.query('surveys');
//   // final surveys = result.map((json) => SurveyModel.fromJsonDB(json)).toList();
// final totalSurvey = Sqflite.firstIntValue(
//   await db.rawQuery('SELECT COUNT(*) FROM surveys'),
// ) ?? 0;
//   final approvedCount = Sqflite.firstIntValue(
//     await db.rawQuery('SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 1'),
//   ) ?? 0;
//  final pendingCount = Sqflite.firstIntValue(
//     await db.rawQuery('SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 0'),
//   ) ?? 0;
//   final consentCount = Sqflite.firstIntValue(
//     await db.rawQuery('SELECT COUNT(*) FROM surveys WHERE consentAvailable = 1'),
//   ) ?? 0;

//   GlobalLists.totalSurvey=totalSurvey.toString();
//    GlobalLists.approvedSurvey=approvedCount.toString();
//     GlobalLists.consentSurvey=consentCount.toString();
//     GlobalLists.pendingSurvey=pendingCount.toString();
//   return {
//     "surveys": totalSurvey,
//     "approvedCount": approvedCount,
//     "consentCount": consentCount,
//   };
// }

  // Delete
  Future<int> deleteSurvey(int id) async {
    final db = await instance.database;
    print("Deleted ${id}");
    return await db.delete('surveys', where: 'id = ?', whereArgs: [id]);
  }

  // Close
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Add this method to run raw update queries
  Future<int> updateRaw(String query, [List<Object?>? arguments]) async {
    final dbClient = await database;
    return await dbClient.rawUpdate(query, arguments);
  }
}
