import 'package:riv2_learn/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'main.dart';

class BmiHistoryDatabase {
  BmiHistoryDatabase(
      {this.id,
      required this.result,
      required this.height,
      required this.weight});

  final int? id;
  final double result;
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

final bmiHistoryDbProvider =
    StateNotifierProvider<BmiHistoryDbController, List>(
        (ref) => BmiHistoryDbController(ref.read));

class BmiHistoryDbController extends StateNotifier<List> {
  BmiHistoryDbController(this._read) : super([]);
  final Reader _read;

  Future<void> insertBmiHistory(BmiHistoryDatabase bmiHistory) async {
    final Database db = await _read(databaseProvider);
    await db.insert(
      'bmi_history',
      bmiHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BmiHistoryDatabase>> getBmiHistory() async {
    final Database db = await _read(databaseProvider);
    final List<Map<String, dynamic>> maps = await db.query('bmi_history');
    return List.generate(
      maps.length,
      (index) {
        return BmiHistoryDatabase(
          result: maps[index]['result'],
          height: maps[index]['height'],
          weight: maps[index]['weight'],
        );
      },
    );
  }

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

  Future<void> deleteBmiHistory(int id) async {
    final Database db = await _read(databaseProvider);
    await db.delete(
      'bmi_history',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
