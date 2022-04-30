import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/controller.dart';

class CounterApp extends HookConsumerWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final counterNotifier = ref.watch(counterProvider.notifier);

    useEffect(() {
      Future(() async {
        await counterNotifier.getCounterPrefs();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('CounterApp')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('count: $counter'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('プラス'),
                  onPressed: () {
                    counterNotifier.increment();
                    counterNotifier.setCounterPrefs();
                  },
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  child: const Text('マイナス'),
                  onPressed: () {
                    counterNotifier.decrement();
                    counterNotifier.setCounterPrefs();
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('削除'),
              onPressed: () {
                counterNotifier.clear();
                counterNotifier.setCounterPrefs();
              },
            ),
          ],
        ),
      ),
    );
  }
}
