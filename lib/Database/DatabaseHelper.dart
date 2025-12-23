import 'dart:async';
import 'dart:io';
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
        serverSynced INTEGER,
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
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  survey_local_id INTEGER,      -- surveys.id (FK)
  server_media_id TEXT,         -- returned by server
  media_type TEXT,              -- land | survey | consent
  local_path TEXT,              -- file path OR server url
  is_synced INTEGER,            -- 0 / 1
  is_deleted INTEGER,           -- 0 / 1
  created_at INTEGER,

  UNIQUE (survey_local_id, media_type, local_path)
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

  }
Future<void> insertSurveyMedia({
  required int surveyLocalId,
  required String file,
  required String mediaType,
}) async {
  final db = await database;

  await db.insert('survey_media', {
    'survey_local_id': surveyLocalId,
    'server_media_id': null,
    'media_type': mediaType, // land / survey / consent
    'local_path': file,
    'is_synced': 0,
    'is_deleted': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
}
// Future<int> insertSurveyMediaList({
//   required String surveyLocalId, // keep as String now
//   List<SurveyMediaModel>? landPictures,
//   List<SurveyMediaModel>? surveyForms,
//   List<SurveyMediaModel>? consentForms,
// }) async {
//   final db = await database;
//   int totalInserted = 0;

//   // Example for landPictures
//   if (landPictures != null) {
//     for (var media in landPictures) {
//       totalInserted += await db.insert('survey_media', media.toMap());
//     }
//   }

//   // Example for surveyForms
//   if (surveyForms != null) {
//     for (var media in surveyForms) {
//       totalInserted += await db.insert('survey_media', media.toMap());
//     }
//   }

//   // Example for consentForms
//   if (consentForms != null) {
//     for (var media in consentForms) {
//       totalInserted += await db.insert('survey_media', media.toMap());
//     }
//   }

//   return totalInserted; // returns total number of rows inserted
// }

Future<bool> mediaExists({
  required String surveyLocalId,
  required String mediaType,
  required String localPath,
}) async {
  final db = await database;
  final result = await db.query(
    'survey_media',
    where:
        'survey_local_id = ? AND media_type = ? AND local_path = ? AND is_deleted = 0',
    whereArgs: [surveyLocalId, mediaType, localPath],
    limit: 1,
  );
  return result.isNotEmpty;
}

Future<int> insertSurveyMediaList({
  required String surveyLocalId,
  List<SurveyMediaModel>? landPictures,
  List<SurveyMediaModel>? surveyForms,
  List<SurveyMediaModel>? consentForms,
}) async {
  final db = await database;
  int totalInserted = 0;
   print("INSERT SURVEY MEDIA");
 print(landPictures!.length.toString());
 Future<void> addMedia(List<SurveyMediaModel>? files, String type) async {
  if (files == null || files.isEmpty) return;

  for (final file in files) {

    final map = {
      'survey_local_id': file.surveyLocalId,
      'server_media_id': file.serverMediaId,
      'media_type': type,
      'local_path': file.localPath,
      'is_synced': file.isSynced,
      'is_deleted': 0,
      'created_at': file.createdAt,
    };

    print("📝Map media value before inserting:  $map");

    // ✅ INSERT ONCE
    // final insertedId = await db.insert('survey_media', map);
    final insertedId = await db.insert(
  'survey_media',
  map,
  conflictAlgorithm: ConflictAlgorithm.ignore,
);

if (insertedId == 0) {
  print("⏭ Duplicate ignored: ${file.localPath}");
} else {
  print("✅ Inserted: ${file.localPath}");
}

     print("RANGAMEDIA ${insertedId}");
    // 🔑 VERY IMPORTANT
    // Save DB ID back into model so next save won't duplicate
    // file.id = insertedId;

    totalInserted++;
  }
}

  await addMedia(landPictures, 'land');
  await addMedia(surveyForms, 'survey');
  await addMedia(consentForms, 'consent');

  print("✅ Total rows inserted: $totalInserted");
  return totalInserted;
}

// Future<int> insertSurveyMediaList({
//   required String surveyLocalId, // keep as String
//   List<SurveyMediaModel>? landPictures,
//   List<SurveyMediaModel>? surveyForms,
//   List<SurveyMediaModel>? consentForms,
// }) async {
//   final db = await database;
//   int totalInserted = 0;

//   // Make this function async so we can await db.insert
//   Future<void> addMedia(List<SurveyMediaModel>? files, String type) async {
//     if (files == null) return;
//     for (var file in files) {
//       final map = {
//         'survey_local_id': surveyLocalId,
//         'server_media_id': file.serverMediaId,
//         'media_type': type,
//         'local_path': file.localPath,
//         'is_synced': 0,
//         'is_deleted': 0,
//         'created_at': DateTime.now().millisecondsSinceEpoch,
//       };

//       print("📝 Inserting media: $map");
//       totalInserted += await db.insert('survey_media', map); // ✅ await here
//     }
//   }

//   await addMedia(landPictures, 'land');
//   await addMedia(surveyForms, 'survey');
//   await addMedia(consentForms, 'consent');

//   print("✅ Total rows inserted: $totalInserted");
//   return totalInserted;
// }
Future<int> deleteSurveyMedia({
  required String surveyLocalId,
  required String localPath,
}) async {
  final db = await database;

  final rows = await db.delete(
    'survey_media',
    where: 'survey_local_id = ? AND local_path = ?',
    whereArgs: [surveyLocalId, localPath],
  );

  print("🗑 Deleted rows: $rows");
  return rows;
}

Future<int> hardDeleteSurveyMediaByServerId({
  required String surveyLocalId,
 
}) async {
  final db = await database;

  final rows = await db.delete(
    'survey_media',
    where: '''
      survey_local_id = ?
    
    ''',
    whereArgs: [
      surveyLocalId,
      
    ],
  );

  print("🗑 HARD deleted rows: $rows ");
  return rows;
}


Future<int> upsertSurveyMediaList({
  required String surveyLocalId,
  List<SurveyMediaModel> landPictures = const [],
  List<SurveyMediaModel> surveyForms = const [],
  List<SurveyMediaModel> consentForms = const [],
}) async {
  final db = await database;
  int totalAffected = 0;

  Future<void> upsert(List<SurveyMediaModel> files, String type) async {
    for (final file in files) {
      final existing = await db.query(
        'survey_media',
        where: 'survey_local_id = ? AND server_media_id = ?',
        whereArgs: [surveyLocalId, file.serverMediaId],
      );

      final map = {
        'survey_local_id': surveyLocalId,
        'server_media_id': file.serverMediaId,
        'media_type': type,
        'local_path': file.localPath,
        'is_synced': 0,
        'is_deleted': 0,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

      if (existing.isEmpty) {
        await db.insert('survey_media', map);
        totalAffected++;
      } else {
        await db.update(
          'survey_media',
          map,
          where: 'survey_local_id = ? AND server_media_id = ?',
          whereArgs: [surveyLocalId, file.serverMediaId],
        );
        totalAffected++;
      }
    }
  }

  await upsert(landPictures, 'land');
  await upsert(surveyForms, 'survey');
  await upsert(consentForms, 'consent');

  return totalAffected;
}

// Future<void> insertSurveyMediaList({
//   required int surveyLocalId,
//   List<SurveyMediaModel> landPictures = const [],
//   List<SurveyMediaModel> surveyForms = const [],
//   List<SurveyMediaModel> consentForms = const [],
// }) async {
//   final db = await database;
//   final batch = db.batch();

//   void addMedia(List<SurveyMediaModel> files, String type) {
//     for (final file in files) {
//       final map = {
//         'survey_local_id': surveyLocalId,
//         'server_media_id': file.id,
//         'media_type': type,
//         'local_path': file.localPath,
//         'is_synced': 0,
//         'is_deleted': 0,
//         'created_at': DateTime.now().millisecondsSinceEpoch,
//       };

//       print("📝 Inserting media: $map"); // ✅ print inserted value
//       batch.insert('survey_media', map);
//     }
//   }

//   addMedia(landPictures, 'land');
//   addMedia(surveyForms, 'survey');
//   addMedia(consentForms, 'consent');

//   await batch.commit(noResult: true);

//   print("✅ Batch insert committed for survey $surveyLocalId");
// }

// Future<void> insertSurveyMediaList({
//   required int surveyLocalId,
//   List<SurveyMediaModel> landPictures = const [],
//   List<SurveyMediaModel> surveyForms = const [],
//   List<SurveyMediaModel> consentForms = const [],
// }) async {
//   final db = await database;
//   final batch = db.batch();

//   void addMedia(List<SurveyMediaModel> files, String type) {
//     for (final file in files) {
//       batch.insert('survey_media', {
//         'survey_local_id': surveyLocalId,
//         'server_media_id': file.id,
//         'media_type': type,
//         'local_path': file.localPath,
//         'is_synced': 0,
//         'is_deleted': 0,
//         'created_at': DateTime.now().millisecondsSinceEpoch,
//       });
//     }
//   }

//   addMedia(landPictures, 'land');
//   addMedia(surveyForms, 'survey');
//   addMedia(consentForms, 'consent');

//   await batch.commit(noResult: true);
// }
Future<int> updateSurveySyncFlags({
  required String surveyId,
  required int syncStatus,
  required int serverSynced,
  required String surveyStatus,
}) async {
  final db = await database;
print("RUCHITA UPDATED updateSurveySyncFlags IN LOCAL DB");
  return await db.update(
    'surveys',
    {
      'isSync': syncStatus,
      'serverSynced': serverSynced,
      'surveyStatus': surveyStatus,
    },
    where: 'surveyId = ?',
    whereArgs: [surveyId],
  );
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
Future<List<SurveyMediaModel>> getSurveyMediaBySurveyLocalId(
    String surveyLocalId) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'survey_media',
    where: 'survey_local_id = ?',
    whereArgs: [surveyLocalId],
    orderBy: 'id ASC',
  );
  print("MEdia LIST DATa");
print(maps);
  return maps.map((e) => SurveyMediaModel.fromMap(e)).toList();
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
Future<List<SurveyMediaModel>> getSurveyMedia(String surveyLocalId) async {
  print("GetSurveyMedia");
  print(surveyLocalId);
  final db = await database;
  final res = await db.query(
    'survey_media',
    where: 'survey_local_id = ? AND is_deleted = 0',
    whereArgs: [surveyLocalId],
  );
  print(res);
  return res.map((e) => SurveyMediaModel.fromMap(e)).toList();
}
  Future<int> mediaCunt() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM survey_media");
    return Sqflite.firstIntValue(result) ?? 0;
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
    return await db.insert('surveys', survey.toJsonDB(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }
Future<bool> surveyExists(String surveyId) async {
  final db = await database;

  final result = await db.query(
    'surveys',
    where: 'surveyId = ?',
    whereArgs: [surveyId],
    limit: 1,
  );

  return result.isNotEmpty;
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
Future<void> printAllSurveys(String surveyID) async {
  final surveys = await DatabaseHelper.instance.getSurveyMedia(surveyID);
print(surveys);
  if (surveys.isEmpty) {
    print("No surveys found in DB.");
  } else {
    for (var survey in surveys) {
      print("=== Survey ID: ${survey.surveyLocalId} ===");
      print("Land Pictures:");
      // for (var media in survey.) {
        print("  Media ID: ${survey.serverMediaId}");
        print("  Local Path: ${survey.localPath}");
        print("  Media Type: ${survey.mediaType}");
      }

      // print("Survey Forms:");
      // for (var media in survey.surveyForms) {
      //   print("  Media ID: ${media.id}");
      //   print("  Local Path: ${media.localPath}");
      //   print("  Media Type: ${media.mediaType}");
      // }

      // print("Consent Forms:");
      // for (var media in survey.consentForms) {
      //   print("  Media ID: ${media.id}");
      //   print("  Local Path: ${media.localPath}");
      //   print("  Media Type: ${media.mediaType}");
      // }
    // }
  }
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
