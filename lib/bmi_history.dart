import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'controller.dart';

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiHistoryList = ref.watch(bmiHistoryProvider);
    final bmiHistoryState = ref.watch(bmiHistoryProvider.notifier);

    useEffect(() {
      bmiHistoryState.getDb();
      return null;
    }, []);

    return Scaffold(
      body: ListView.builder(
        itemCount: bmiHistoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'ID: ${bmiHistoryList[index]['id']}  '
                      '身長: ${bmiHistoryList[index]['height']}  '
                      '体重: ${bmiHistoryList[index]['weight']}  '
                      'BMI: ${bmiHistoryList[index]['result']}',
                    ),
                  ),
                ),
              ],
            ),
            onDismissed: (d) {
              bmiHistoryState.deleteDb(bmiHistoryList[index]['id']);
            },
          );
        },
      ),
    );
  }
}
