import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/controller.dart';

class BmiCalculator extends HookConsumerWidget {
  const BmiCalculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculate = ref.watch(bmiCalcProvider);
    final calculateState = ref.watch(bmiCalcProvider.notifier);

    final heightTextEditingController = useTextEditingController();
    final weightTextEditingController = useTextEditingController();

    return Scaffold(
      body: Form(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('結果: $calculate'),
              TextFormField(
                controller: heightTextEditingController,
                decoration: const InputDecoration(
                  labelText: '身長',
                  hintText: '身長を入力',
                ),
              ),
              TextFormField(
                controller: weightTextEditingController,
                decoration: const InputDecoration(
                  labelText: '体重',
                  hintText: '体重を入力',
                ),
              ),
              ElevatedButton(
                child: const Text('計算'),
                onPressed: () {
                  calculateState.calculate(
                    heightTextEditingController.text,
                    weightTextEditingController.text,
                  );
                  calculateState.setDb(
                    heightTextEditingController.text,
                    weightTextEditingController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
