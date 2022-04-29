import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterApp extends HookConsumerWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('count:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('プラス'),
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  child: const Text('マイナス'),
                  onPressed: () {},
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('削除'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
