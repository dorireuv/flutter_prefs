import 'package:flutter_cache/src/cache_value_def.dart';
import 'package:flutter_cache/src/cache_value_with_default_def.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = 'key';

  group('withDefault', () {
    test('invalid default --> throws ArgumentError', () async {
      final cacheValueDef = CacheValueDef.string(key, blacklisted: ['invalid']);
      expect(() => cacheValueDef.withDefault('invalid'), throwsArgumentError);
    });
  });
}
