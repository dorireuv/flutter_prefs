import 'package:shared_preferences/shared_preferences.dart';

import 'prefs_value.dart';
import 'prefs_value_with_default_def.dart';

/// A value stored in a prefs but instead of setting the default value, the
/// prefs remain cleared. Also the get method returns the default value if no
/// value is stored.
abstract class PrefsValueWithDefault<T extends Object> {
  factory PrefsValueWithDefault({
    required PrefsValue<T> prefsValue,
    required T default_,
  }) {
    return _PrefsValueWithDefault(prefsValue: prefsValue, default_: default_);
  }

  T get default_;

  T get();

  Future<bool> set(T v);

  Future<bool> clear();
}

class _PrefsValueWithDefault<T extends Object>
    implements PrefsValueWithDefault<T> {
  final PrefsValue<T> _prefsValue;
  final T _default;

  _PrefsValueWithDefault({
    required PrefsValue<T> prefsValue,
    required T default_,
  })  : _prefsValue = prefsValue,
        _default = default_;

  @override
  T get default_ => _default;

  @override
  T get() {
    return _prefsValue.getOrDefault(_default);
  }

  @override
  Future<bool> set(T v) {
    return v != _default ? _prefsValue.set(v) : _prefsValue.clear();
  }

  @override
  Future<bool> clear() {
    return _prefsValue.clear();
  }
}

extension PrefsValueWithDefaultExpressiveApiExtension<T extends Object>
    on PrefsValueWithDefault<T> {
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

extension PrefsValueWithDefaultFromDefExtension<T extends Object>
    on PrefsValueWithDefaultDef<T> {
  PrefsValueWithDefault<T> create(SharedPreferences prefs) {
    return PrefsValueWithDefault(
        prefsValue: PrefsValue(prefs: prefs, def: this), default_: default_);
  }
}

extension PrefsValueWithDefaultFromPrefsValueExtension<T extends Object>
    on PrefsValue<T> {
  PrefsValueWithDefault<T> withDefault(T default_) {
    return PrefsValueWithDefault(prefsValue: this, default_: default_);
  }
}
