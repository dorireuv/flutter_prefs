import 'prefs_value_def.dart';

abstract class PrefsValueWithDefaultDef<T extends Object>
    extends PrefsValueDef<T> {
  T get default_;
}

class _PrefsValueWithDefaultDef<T extends Object>
    implements PrefsValueWithDefaultDef<T> {
  final PrefsValueDef<T> _def;

  @override
  final T default_;

  const _PrefsValueWithDefaultDef(
      {required PrefsValueDef<T> def, required this.default_})
      : _def = def;

  @override
  String get key => _def.key;

  @override
  Formatter<T> get formatter => _def.formatter;

  @override
  Parser<T> get parser => _def.parser;

  @override
  Validator<T>? get validator => _def.validator;
}

extension PrefsValueDefToWithDefaultExtension<T extends Object>
    on PrefsValueDef<T> {
  PrefsValueWithDefaultDef<T> withDefault(T default_) {
    final validator_ = validator;
    if (validator_ != null && !validator_(default_)) {
      throw ArgumentError('Default value $default_ is invalid');
    }
    return _PrefsValueWithDefaultDef(def: this, default_: default_);
  }
}
