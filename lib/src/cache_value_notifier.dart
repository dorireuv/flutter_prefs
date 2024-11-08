import 'package:flutter/material.dart';

import 'cache_value.dart';

abstract class CacheValueNotifier<T extends Object>
    implements CacheValue<T>, Listenable {
  factory CacheValueNotifier(CacheValue<T> cacheValue) {
    return _CacheValueNotifier(cacheValue);
  }
}

class _CacheValueNotifier<T extends Object>
    with ChangeNotifier
    implements CacheValueNotifier<T> {
  final CacheValue<T> _cacheValue;

  _CacheValueNotifier(this._cacheValue);

  @override
  T? get() {
    return _cacheValue.get();
  }

  @override
  Future<bool> set(T v) async {
    return _doAndNotifyListeners(() => _cacheValue.set(v));
  }

  @override
  Future<bool> clear() async {
    return _doAndNotifyListeners(_cacheValue.clear);
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
