import 'package:flutter/material.dart';

import 'cache_value_with_default.dart';

/// Cache value with default value which notifies listeners upon changes.
abstract class CacheValueWithDefaultNotifier<T extends Object>
    implements CacheValueWithDefault<T>, Listenable {
  factory CacheValueWithDefaultNotifier(
      CacheValueWithDefault<T> cacheValueWithDefault) {
    return _CacheValueWithDefaultNotifier(cacheValueWithDefault);
  }
}

class _CacheValueWithDefaultNotifier<T extends Object>
    with ChangeNotifier
    implements CacheValueWithDefaultNotifier<T> {
  final CacheValueWithDefault<T> _cacheValueWithDefault;

  _CacheValueWithDefaultNotifier(this._cacheValueWithDefault);

  @override
  Future<bool> clear() async {
    return _doAndNotifyListeners(_cacheValueWithDefault.clear);
  }

  @override
  T get default_ => _cacheValueWithDefault.default_;

  @override
  T get() {
    return _cacheValueWithDefault.get();
  }

  @override
  Future<bool> set(T v) async {
    return _doAndNotifyListeners(() => _cacheValueWithDefault.set(v));
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

extension CacheValueWithDefaultToWithNotifierExtension<T extends Object>
    on CacheValueWithDefault<T> {
  CacheValueWithDefaultNotifier<T> withNotifier() =>
      CacheValueWithDefaultNotifier(this);
}
