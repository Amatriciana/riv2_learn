import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/controller.dart';
import 'package:riv2_learn/database.dart';

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aaa = ref.watch(bmiHistoryProvider);
    final bbb = ref.watch(bmiHistoryProvider.notifier);

    useEffect(() {
      bbb.getDb();
      return null;
    }, []);

    return Scaffold(
      body: Text(
        aaa.toString(),
      ),
    );
  }
}
