import 'cache_value_def.dart';

abstract class CacheValueWithDefaultDef<T extends Object>
    extends CacheValueDef<T> {
  T get default_;
}

class _CacheValueWithDefaultDef<T extends Object>
    implements CacheValueWithDefaultDef<T> {
  final CacheValueDef<T> _def;

  @override
  final T default_;

  const _CacheValueWithDefaultDef(
      {required CacheValueDef<T> def, required this.default_})
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

extension CacheValueDefToWithDefaultExtension<T extends Object>
    on CacheValueDef<T> {
  CacheValueWithDefaultDef<T> withDefault(T default_) {
    final validator_ = validator;
    if (validator_ != null && !validator_(default_)) {
      throw ArgumentError('Default value $default_ is invalid');
    }
    return _CacheValueWithDefaultDef(def: this, default_: default_);
  }
}
