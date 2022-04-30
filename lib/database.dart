import 'package:sqflite/sqflite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';

import 'controller.dart';

// モデルクラス
class BmiHistoryDatabase {
  BmiHistoryDatabase(
      {this.id,
      required this.result,
      required this.height,
      required this.weight});

  final int? id;
  final String result;
  final double height;
  final double weight;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'result': result,
      'height': height,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'BmiHistory{id: $id, result: $result, height: $height, weight: $weight}';
  }
}

/* TODO Providerである必要があるのか？
ref.readを使いたく_readを使うためにProviderにした
もっといいやり方ありそう */
final bmiHistoryDbProvider =
    StateNotifierProvider<BmiHistoryDbController, List>(
        (ref) => BmiHistoryDbController(ref.read));

class BmiHistoryDbController extends StateNotifier<List> {
  BmiHistoryDbController(this._read) : super([]);
  final Reader _read;

  // table'bmi_history'にデータを保存
  Future<void> insertBmiHistory(BmiHistoryDatabase bmiHistory) async {
    final Database db = await _read(databaseProvider);
    await db.insert(
      'bmi_history',
      bmiHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // table'bmi_history'を読み込み、Listに格納し、Listを返す'
  Future<List<BmiHistoryDatabase>> getBmiHistory() async {
    final Database db = await _read(databaseProvider);
    final List<Map<String, dynamic>> maps = await db.query('bmi_history');
    return List.generate(
      maps.length,
      (index) {
        return BmiHistoryDatabase(
          id: maps[index]['id'],
          result: maps[index]['result'],
          height: maps[index]['height'],
          weight: maps[index]['weight'],
        );
      },
    );
  }

  // table'bmi_history'から指定の'id'があるレコードを更新
  Future<void> updateBmiHistory(BmiHistoryDatabase bmiHistory) async {
    final Database db = await _read(databaseProvider);
    await db.update(
      'bmi_history',
      bmiHistory.toMap(),
      where: "id = ?",
      whereArgs: [bmiHistory.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // table'bmi_history'から指定の'id'があるレコードを削除
  Future<void> deleteBmiHistory(int id) async {
    final Database db = await _read(databaseProvider);
    await db.delete(
      'bmi_history',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

// main関数内でdbを読み込む為のクラス
class DbController {
  // 指定のpathからdbを読み込み、table'bmi_history'を作成
  Future<Database> dbCreate() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bmi_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE bmi_history(id INTEGER PRIMARY KEY AUTOINCREMENT, result TEXT, height REAL, weight REAL)");
      },
      version: 1,
    );
  }
}
