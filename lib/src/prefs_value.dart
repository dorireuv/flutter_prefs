import 'package:shared_preferences/shared_preferences.dart';

import 'prefs_key.dart';
import 'prefs_value_def.dart';

/// A value stored in a prefs.
abstract class PrefsValue<T> {
  factory PrefsValue(
      {required SharedPreferences prefs, required PrefsValueDef<T> def}) {
    return _PrefsValue(prefs: prefs, def: def);
  }

  T? get();

  Future<bool> set(T v);

  Future<bool> clear();
}

class _PrefsValue<T> implements PrefsValue<T> {
  final SharedPreferences _prefs;
  final PrefsValueDef<T> _def;

  _PrefsValue({required SharedPreferences prefs, required PrefsValueDef<T> def})
      : _prefs = prefs,
        _def = def;

  @override
  T? get() {
    final stringValue = _prefs.getString(_key.key);
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
    return _isValid(v)
        ? await _prefs.setString(_key.key, _formatter(v))
        : false;
  }

  @override
  Future<bool> clear() async {
    return _prefs.remove(_key.key);
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

  PrefsKey get _key => _def.key;

  Formatter<T> get _formatter => _def.formatter;

  Parser<T> get _parser => _def.parser;

  Validator<T>? get _validator => _def.validator;
}

extension PrefsValueExpressiveApiExtension<T> on PrefsValue<T> {
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

extension PrefsValueFromDefExtension<T> on PrefsValueDef<T> {
  PrefsValue<T> create(SharedPreferences prefs) {
    return PrefsValue(prefs: prefs, def: this);
  }
}
