import 'package:shared_preferences/shared_preferences.dart';

import 'cache_value_def.dart';

/// A value stored in a cache.
abstract class CacheValue<T extends Object> {
  factory CacheValue(
      {required SharedPreferences prefs, required CacheValueDef<T> def}) {
    return _CacheValue(prefs: prefs, def: def);
  }

  T? get();

  Future<bool> set(T v);

  Future<bool> clear();
}

class _CacheValue<T extends Object> implements CacheValue<T> {
  final SharedPreferences _prefs;
  final CacheValueDef<T> _def;

  _CacheValue({required SharedPreferences prefs, required CacheValueDef<T> def})
      : _prefs = prefs,
        _def = def;

  @override
  T? get() {
    final stringValue = _prefs.getString(_key);
    if (stringValue == null) {
      return null;
    }

    final v = _tryParse(stringValue);
    if (v == null) {
      return null;
    }

    return _filterInvalid(v);
  }

  @override
  Future<bool> set(T v) async {
    return _isValid(v) ? await _prefs.setString(_key, _formatter(v)) : false;
  }

  @override
  Future<bool> clear() async {
    return _prefs.remove(_key);
  }

  T? _tryParse(String stringValue) {
    try {
      return _parser(stringValue);
    } catch (e) {
      // Failed to parse, treat it as not available.
      return null;
    }
  }

  T? _filterInvalid(T v) {
    return _isValid(v) ? v : null;
  }

  bool _isValid(T v) {
    final validator = _validator;
    if (validator == null) {
      return true;
    }

    return validator(v);
  }

  String get _key => _def.key;

  Formatter<T> get _formatter => _def.formatter;

  Parser<T> get _parser => _def.parser;

  Validator<T>? get _validator => _def.validator;
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
