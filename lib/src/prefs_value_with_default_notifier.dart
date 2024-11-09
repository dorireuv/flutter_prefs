import 'package:flutter/material.dart';

import 'prefs_value_with_default.dart';

/// Prefs value with default value which notifies listeners upon changes.
abstract class PrefsValueWithDefaultNotifier<T extends Object>
    implements PrefsValueWithDefault<T>, Listenable {
  factory PrefsValueWithDefaultNotifier(
      PrefsValueWithDefault<T> prefsValueWithDefault) {
    return _PrefsValueWithDefaultNotifier(prefsValueWithDefault);
  }
}

class _PrefsValueWithDefaultNotifier<T extends Object>
    with ChangeNotifier
    implements PrefsValueWithDefaultNotifier<T> {
  final PrefsValueWithDefault<T> _prefsValueWithDefault;

  _PrefsValueWithDefaultNotifier(this._prefsValueWithDefault);

  @override
  Future<bool> clear() async {
    return _doAndNotifyListeners(_prefsValueWithDefault.clear);
  }

  @override
  T get default_ => _prefsValueWithDefault.default_;

  @override
  T get() {
    return _prefsValueWithDefault.get();
  }

  @override
  Future<bool> set(T v) async {
    return _doAndNotifyListeners(() => _prefsValueWithDefault.set(v));
  }

  Future<bool> _doAndNotifyListeners(Future<bool> Function() f) async {
    final res = await f();
    if (!res) {
      return false;
    }

    notifyListeners();
    return true;
  }
}

extension PrefsValueWithDefaultToWithNotifierExtension<T extends Object>
    on PrefsValueWithDefault<T> {
  PrefsValueWithDefaultNotifier<T> withNotifier() =>
      PrefsValueWithDefaultNotifier(this);
}
