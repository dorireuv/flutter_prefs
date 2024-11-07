import 'cache_value_def.dart';

class CacheValueWithDefaultDef<T extends Object> implements CacheValueDef<T> {
  final CacheValueDef<T> def;
  final T default_;

  const CacheValueWithDefaultDef({required this.def, required this.default_});

  @override
  String get key => def.key;

  @override
  Formatter<T> get formatter => def.formatter;

  @override
  Parser<T> get parser => def.parser;

  static CacheValueWithDefaultDef<bool> bool_(
          {required String key, required bool default_}) =>
      CacheValueWithDefaultDef(
          def: CacheValueDef.bool_(key), default_: default_);

  static CacheValueWithDefaultDef<int> int_(
          {required String key, required int default_}) =>
      CacheValueWithDefaultDef(
          def: CacheValueDef.int_(key), default_: default_);

  static CacheValueWithDefaultDef<String> string(
          {required String key, required String default_}) =>
      CacheValueWithDefaultDef(
          def: CacheValueDef.string(key), default_: default_);
}

extension CacheValueDefToWithDefaultExtension<T extends Object>
    on CacheValueDef<T> {
  CacheValueWithDefaultDef<T> withDefault(T default_) =>
      CacheValueWithDefaultDef(def: this, default_: default_);
}
