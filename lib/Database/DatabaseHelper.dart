import 'dart:async';
import 'package:hyworth_land_survey/Utils/GlobalLists.dart';
import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';
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
        surveyStatus TEXT,
        landStateID TEXT,
        landDistrictID TEXT,
        landTalukaID TEXT,
        landVillageID TEXT,
        substationDistrictID TEXT,
        substationTalukaID TEXT,
        substationVillageID TEXT
      )
    ''');
 await db.execute('''
  CREATE TABLE survey_media (
  local_id TEXT PRIMARY KEY,
  survey_local_id INTEGER,      -- surveys.id (FK)
  server_media_id TEXT,         -- returned by server
  media_type TEXT,              -- land / survey / consent
  local_path TEXT,              -- file path OR url
  is_synced INTEGER,            -- 0 / 1
  is_deleted INTEGER,           -- 0 / 1
  created_at INTEGER
)
''');

    await db.execute('''
      CREATE TABLE district(
         id INTEGER PRIMARY KEY,
          state_code TEXT,
    state_name TEXT,
    district_code TEXT,
    district_name TEXT
      )
    ''');

    // Taluka table (independent)
    await db.execute('''
    CREATE TABLE taluka(
      id INTEGER PRIMARY KEY,
        
    state_code TEXT,
    state_name TEXT,
    district_code TEXT,
    district_name TEXT,
    taluka_code TEXT,
    taluka_name TEXT
    )
  ''');

    // Village table (independent)
    await db.execute('''
    CREATE TABLE village(
      id INTEGER PRIMARY KEY,
       state_code TEXT,
    state_name TEXT,
    district_code TEXT,
    district_name TEXT,
    taluka_code TEXT,
    taluka_name TEXT,
     village_code TEXT,
    village_name TEXT
    )
  ''');
    await db.execute('''
  CREATE TABLE states (
    id INTEGER PRIMARY KEY,
    state_code TEXT,
    name TEXT
  )
''');

    await db.execute('''CREATE TABLE IF NOT EXISTS survey_sequence (
  yearMonth INTEGER PRIMARY KEY,
  lastSeq INTEGER
);
''');

    // Insert static Districts
    // await db.insert('district', {'id': '1', 'name': 'Mumbai'});
    // await db.insert('district', {'id': '2', 'name': 'Pune'});
    // await db.insert('district', {'id': '3', 'name': 'Nagpur'});
    // await db.insert('district', {'id': '4', 'name': 'Nashik'});
    // await db.insert('district', {'id': '5', 'name': 'Thane'});
    // await db.insert('district', {'id': '6', 'name': 'Kolhapur'});
    // await db.insert('district', {'id': '7', 'name': 'Aurangabad'});
    // await db.insert('district', {'id': '8', 'name': 'Solapur'});
    // await db.insert('district', {'id': '9', 'name': 'Satara'});
    // await db.insert('district', {'id': '10', 'name': 'Jalgaon'});

    // Insert static Talukas (10 entries)
    // await db.insert('taluka', {'id': '1', 'name': 'Andheri'});
    // await db.insert('taluka', {'id': '2', 'name': 'Bandra'});
    // await db.insert('taluka', {'id': '3', 'name': 'Haveli'});
    // await db.insert('taluka', {'id': '4', 'name': 'Mulshi'});
    // await db.insert('taluka', {'id': '5', 'name': 'Nagpur Rural'});
    // await db.insert('taluka', {'id': '6', 'name': 'Nashik East'});
    // await db.insert('taluka', {'id': '7', 'name': 'Thane West'});
    // await db.insert('taluka', {'id': '8', 'name': 'Kolhapur North'});
    // await db.insert('taluka', {'id': '9', 'name': 'Aurangabad Central'});
    // await db.insert('taluka', {'id': '10', 'name': 'Solapur South'});

    // // Insert static Villages (10 entries)
    // await db.insert('village', {'id': '1', 'name': 'Village A'});
    // await db.insert('village', {'id': '2', 'name': 'Village B'});
    // await db.insert('village', {'id': '3', 'name': 'Village C'});
    // await db.insert('village', {'id': '4', 'name': 'Village D'});
    // await db.insert('village', {'id': '5', 'name': 'Village E'});
    // await db.insert('village', {'id': '6', 'name': 'Village F'});
    // await db.insert('village', {'id': '7', 'name': 'Village G'});
    // await db.insert('village', {'id': '8', 'name': 'Village H'});
    // await db.insert('village', {'id': '9', 'name': 'Village I'});
    // await db.insert('village', {'id': '10', 'name': 'Village J'});
  }
  Future<void> clearTableSurvey() async {
    final db = await database;
    await db.delete('surveys');
  }

  Future<void> clearStates() async {
    final db = await database;
    await db.delete('states');
  }

  Future<void> clearDistrict() async {
    final db = await database;
    await db.delete('district');
  }

  Future<void> clearTaluka() async {
    final db = await database;
    await db.delete('taluka');
  }

  Future<void> clearVillage() async {
    final db = await database;
    await db.delete('village');
  }

  Future<void> insertDistrict(List<DistrictData> list) async {
    final db = await database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'district',
        {
          'id': item.id ?? 0,
          'state_code': item.stateCode ?? '',
          'state_name': item.stateName ?? '',
          'district_code': item.districtCode ?? '',
          'district_name': item.districtName ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertTaluka(List<TalukaData> list) async {
    final db = await database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'taluka',
        {
          'id': item.id,
          'state_code': item.stateCode,
          'state_name': item.stateName,
          'district_code': item.districtCode,
          'district_name': item.districtName,
          'taluka_code': item.talukaCode,
          'taluka_name': item.talukaName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertVillage(List<VillageData> list) async {
    final db = await database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'village',
        {
          'id': item.id,
          'state_code': item.stateCode,
          'state_name': item.stateName,
          'district_code': item.districtCode,
          'district_name': item.districtName,
          'village_code': item.villageCode,
          'village_name': item.villageName,
          'taluka_code': item.talukaCode,
          'taluka_name': item.talukaName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertStates(List<StateData> list) async {
    final db = await database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'states',
        {
          'id': item.id ?? 0,
          'state_code': item.stateCode ?? '',
          'name': item.name ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> stateCount() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM states");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<StateData>> getStates() async {
    final db = await database;
    final result = await db.query('states');

    return result
        .map((e) => StateData(
              id: e['id'] as int?,
              stateCode: e['state_code'] as String?,
              name: e['name'] as String?,
            ))
        .toList();
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
    print("INSERTED SURVEY");
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
        if (key.contains('Capacity') ||
            key.contains('AC') ||
            key.contains('DC')) return 0;
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
      await db
          .rawQuery('SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 1'),
    );
    return result ?? 0;
  }

  Future<int> getConsentAvailableCount() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
      await db
          .rawQuery('SELECT COUNT(*) FROM surveys WHERE consentAvailable = 1'),
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
        ) ??
        0;

    // ✅ Approved
    final approvedCount = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 1 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
            whereArgs,
          ),
        ) ??
        0;

    // ✅ Pending
    final pendingCount = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM surveys WHERE isSurveyapproved = 0 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
            whereArgs,
          ),
        ) ??
        0;

    // ✅ Consent
    final consentCount = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM surveys WHERE consentAvailable = 1 ${whereClause.isNotEmpty ? "AND $whereClause" : ""}',
            whereArgs,
          ),
        ) ??
        0;

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
