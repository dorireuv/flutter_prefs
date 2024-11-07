import 'package:flutter/material.dart';

import 'cache_value_with_default.dart';

class CacheValueWithDefaultNotifier<T extends Object>
    with ChangeNotifier
    implements CacheValueWithDefault<T> {
  final CacheValueWithDefault<T> _cacheValueWithDefault;

  CacheValueWithDefaultNotifier(this._cacheValueWithDefault);

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
