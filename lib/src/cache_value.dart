import 'package:shared_preferences/shared_preferences.dart';

import 'cache_value_def.dart';

/// A value stored in a cache.
class CacheValue<T extends Object> {
  final SharedPreferences _prefs;
  final CacheValueDef<T> _def;

  CacheValue({
    required SharedPreferences prefs,
    required CacheValueDef<T> def,
  })  : _prefs = prefs,
        _def = def;

  T? get() {
    final v = _prefs.getString(_key);
    if (v == null) {
      return null;
    }

    try {
      return _parser(v);
    } catch (e) {
      // Failed to parse, treat it as not available.
      return null;
    }
  }

  Future<bool> set(T v) async {
    return _prefs.setString(_key, _formatter(v));
  }

  Future<bool> clear() async {
    return _prefs.remove(_key);
  }

  String get _key => _def.key;

  Formatter<T> get _formatter => _def.formatter;

  Parser<T> get _parser => _def.parser;
}

extension CacheValueExpressiveApiExtension<T extends Object> on CacheValue<T> {
  T getOrDefault(T default_) {
    return get() ?? default_;
  }

  Future<bool> setIfChanged(T v) async {
    return v != get() ? await set(v) : true;
  }

  Future<bool> clearIfSet() async {
    return get() != null ? await clear() : true;
  }

  Future<bool> setIfChangedOrClearIfSet(T? v) async {
    return v != null ? setIfChanged(v) : clearIfSet();
  }
}

extension CacheValueFromDefExtension<T extends Object> on CacheValueDef<T> {
  CacheValue<T> create(SharedPreferences prefs) {
    return CacheValue(prefs: prefs, def: this);
  }
}
