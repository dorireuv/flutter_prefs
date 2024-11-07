import 'package:flutter/material.dart';

import 'cache_value.dart';

class CacheValueNotifier<T extends Object>
    with ChangeNotifier
    implements CacheValue<T> {
  final CacheValue<T> _cacheValue;

  CacheValueNotifier(this._cacheValue);

  @override
  Future<bool> clear() async {
    return _doAndNotifyListeners(_cacheValue.clear);
  }

  @override
  T? get() {
    return _cacheValue.get();
  }

  @override
  Future<bool> set(T v) async {
    return _doAndNotifyListeners(() => _cacheValue.set(v));
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

extension CacheValueToWithNotifierExtension<T extends Object> on CacheValue<T> {
  CacheValueNotifier<T> withNotifier() => CacheValueNotifier(this);
}
