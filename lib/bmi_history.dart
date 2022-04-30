import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'controller.dart';

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiHistory = ref.watch(bmiHistoryProvider);
    final bmiHistoryNotifier = ref.watch(bmiHistoryProvider.notifier);

    useEffect(() {
      bmiHistoryNotifier.getDb();
      return null;
    }, []);

    return Scaffold(
      body: ListView.builder(
        itemCount: bmiHistory.length,
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
                      'ID: ${bmiHistory[index]['id']}  '
                      '身長: ${bmiHistory[index]['height']}  '
                      '体重: ${bmiHistory[index]['weight']}  '
                      'BMI: ${bmiHistory[index]['result']}',
                    ),
                  ),
                ),
              ],
            ),
            onDismissed: (d) {
              bmiHistoryNotifier.deleteDb(bmiHistory[index]['id']);
            },
          );
        },
      ),
    );
  }
}
