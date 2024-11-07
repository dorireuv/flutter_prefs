import 'package:shared_preferences/shared_preferences.dart';

import 'cache_value.dart';
import 'cache_value_with_default_def.dart';

/// A value stored in a cache with a but instead of setting the default value,
/// the cache remains clear.
class CacheValueWithDefault<T extends Object> {
  final CacheValue<T> _cacheValue;
  final T _default;

  CacheValueWithDefault({
    required CacheValue<T> cacheValue,
    required T default_,
  })  : _cacheValue = cacheValue,
        _default = default_;

  T get default_ => _default;

  T get() {
    return _cacheValue.getOrDefault(_default);
  }

  Future<bool> set(T v) {
    return v != _default ? _cacheValue.set(v) : _cacheValue.clear();
  }

  Future<bool> clear() {
    return _cacheValue.clear();
  }
}

extension CacheValueWithDefaultExpressiveApiExtension<T extends Object>
    on CacheValueWithDefault<T> {
  Future<bool> setIfChanged(T v) async {
    return v != get() ? await set(v) : true;
  }

  Future<bool> clearIfSet() async {
    return get() != default_ ? await clear() : true;
  }

  Future<bool> setIfChangedOrClearIfSet(T? v) async {
    return v != null ? setIfChanged(v) : clearIfSet();
  }
}

extension CacheValueWithDefaultFromDefExtension<T extends Object>
    on CacheValueWithDefaultDef<T> {
  CacheValueWithDefault<T> create(SharedPreferences prefs) {
    return CacheValueWithDefault(
        cacheValue: CacheValue(prefs: prefs, def: this), default_: default_);
  }
}
