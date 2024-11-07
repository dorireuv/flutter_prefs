import 'cache_value_def.dart';

final class CacheValueDefs {
  CacheValueDefs._();

  static CacheValueDef<T> value<T extends Object>({
    required String key,
    required Formatter<T> formatter,
    required Parser<T> parser,
  }) =>
      CacheValueDef(key: key, formatter: formatter, parser: parser);

  static CacheValueDef<bool> bool_(String key) => CacheValueDef.bool_(key);

  static CacheValueDef<int> int_(String key) => CacheValueDef.int_(key);

  static CacheValueDef<String> string(String key) => CacheValueDef.string(key);
}
