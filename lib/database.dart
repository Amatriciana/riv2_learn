import 'package:sqflite/sqflite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';

import 'controller.dart';

// モデルクラス
class BmiDatabase {
  BmiDatabase(
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
ref.readを使いたく_refを使うためにProviderにした
もっといいやり方ありそう */
final bmiDbProvider =
    StateNotifierProvider<BmiDbNotifier, List>((ref) => BmiDbNotifier(ref));

class BmiDbNotifier extends StateNotifier<List> {
  BmiDbNotifier(this._ref) : super([]);
  final Ref _ref;

  // table'bmi_history'にデータを保存
  Future<void> insertBmiHistory(BmiDatabase bmiHistory) async {
    final Database db = await _ref.read(databaseProvider);
    await db.insert(
      'bmi_history',
      bmiHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // table'bmi_history'を読み込み、Listに格納し、Listを返す'
  Future<List<BmiDatabase>> getBmiHistory() async {
    final Database db = await _ref.read(databaseProvider);
    final List<Map<String, dynamic>> maps = await db.query('bmi_history');
    return List.generate(
      maps.length,
      (index) {
        return BmiDatabase(
          id: maps[index]['id'],
          result: maps[index]['result'],
          height: maps[index]['height'],
          weight: maps[index]['weight'],
        );
      },
    );
  }

  // table'bmi_history'から指定の'id'があるレコードを更新
  Future<void> updateBmiHistory(BmiDatabase bmiHistory) async {
    final Database db = await _ref.read(databaseProvider);
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
    final Database db = await _ref.read(databaseProvider);
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
