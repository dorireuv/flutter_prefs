typedef Formatter<T> = String Function(T);
typedef Parser<T> = T? Function(String);

class CacheValueDef<T extends Object> {
  final String key;
  final Formatter<T> formatter;
  final Parser<T> parser;

  const CacheValueDef(
      {required this.key, required this.formatter, required this.parser});

  static CacheValueDef<bool> bool_(String key) => CacheValueDef(
      key: key, formatter: (v) => v.toString(), parser: bool.tryParse);

  static CacheValueDef<int> int_(String key) => CacheValueDef(
      key: key, formatter: (v) => v.toString(), parser: int.tryParse);

  static CacheValueDef<String> string(String key) =>
      CacheValueDef(key: key, formatter: (v) => v, parser: (v) => v);
}
