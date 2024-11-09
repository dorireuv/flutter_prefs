import 'package:flutter/material.dart';

import 'prefs_value.dart';

abstract class PrefsValueNotifier<T extends Object>
    implements PrefsValue<T>, Listenable {
  factory PrefsValueNotifier(PrefsValue<T> prefsValue) {
    return _PrefsValueNotifier(prefsValue);
  }
}

class _PrefsValueNotifier<T extends Object>
    with ChangeNotifier
    implements PrefsValueNotifier<T> {
  final PrefsValue<T> _prefsValue;

  _PrefsValueNotifier(this._prefsValue);

  @override
  T? get() {
    return _prefsValue.get();
  }

  @override
  Future<bool> set(T v) async {
    return _doAndNotifyListeners(() => _prefsValue.set(v));
  }

  @override
  Future<bool> clear() async {
    return _doAndNotifyListeners(_prefsValue.clear);
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

extension PrefsValueToWithNotifierExtension<T extends Object> on PrefsValue<T> {
  PrefsValueNotifier<T> withNotifier() => PrefsValueNotifier(this);
}
