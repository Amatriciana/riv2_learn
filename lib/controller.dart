import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomNavProvider = StateProvider<BottomNav>((ref) => BottomNav.counter);

enum BottomNav {
  counter,
  bmiCalc,
  bmiHistory,
}