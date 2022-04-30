import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/controller.dart';

class CounterApp extends HookConsumerWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final countState = ref.watch(counterProvider.notifier);

    useEffect(() {
      Future(() async {
        await countState.getCounterPrefs();
      });
      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('count: $count'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('プラス'),
                  onPressed: () {
                    countState.increment();
                    countState.setCounterPrefs();
                  },
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  child: const Text('マイナス'),
                  onPressed: () {
                    countState.decrement();
                    countState.setCounterPrefs();
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('削除'),
              onPressed: () {
                countState.clear();
                countState.setCounterPrefs();
              },
            ),
          ],
        ),
      ),
    );
  }
}
