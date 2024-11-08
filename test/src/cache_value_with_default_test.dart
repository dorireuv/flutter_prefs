import 'package:flutter_cache/flutter_cache.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'prefs_spy.dart';

void main() async {
  const key = 'key';
  const default_ = 'default';

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  late MockSharedPreferences prefsSpy;

  late CacheValueWithDefault<String> cacheValueWithDefault;

  setUp(() async {
    await prefs.clear();
    prefsSpy = newPrefsSpy(prefs);
    cacheValueWithDefault =
        CacheValueDef.string(key).withDefault(default_).create(prefsSpy);
  });

  group('get', () {
    test('not set --> default', () async {
      expect(cacheValueWithDefault.get(), default_);
    });

    test('set --> value', () async {
      await cacheValueWithDefault.set('value');
      expect(cacheValueWithDefault.get(), 'value');
    });
  });

  group('set', () {
    test('not set and default --> does not set', () async {
      await cacheValueWithDefault.set(default_);
      expect(prefs.getString(key), isNull);
    });

    test('set and default --> clears', () async {
      await cacheValueWithDefault.set('not default');
      await cacheValueWithDefault.set(default_);
      expect(prefs.getString(key), isNull);
    });

    test('not default --> set', () async {
      await cacheValueWithDefault.set('not default');
      expect(cacheValueWithDefault.get(), 'not default');
    });
  });

  group('setIfChanged', () {
    test('not set and default --> does not set', () async {
      await cacheValueWithDefault.setIfChanged(default_);
      expect(prefs.getString(key), isNull);
    });

    test('already set and default --> clears', () async {
      await cacheValueWithDefault.set('not default');
      await cacheValueWithDefault.setIfChanged(default_);
      expect(prefs.getString(key), isNull);
    });

    test('not changed --> not set', () async {
      await cacheValueWithDefault.set('value');
      await cacheValueWithDefault.setIfChanged('value');
      verify(prefsSpy.setString(any, any)).called(1);
    });

    test('changed --> sets', () async {
      await cacheValueWithDefault.set('value1');
      await cacheValueWithDefault.setIfChanged('value2');
      expect(cacheValueWithDefault.get(), 'value2');
    });
  });

  group('clear', () {
    test('set --> clears', () async {
      await cacheValueWithDefault.set('value');
      await cacheValueWithDefault.clear();
      expect(cacheValueWithDefault.get(), default_);
    });

    test('not set --> returns normally', () async {
      await cacheValueWithDefault.clear();
      expect(cacheValueWithDefault.get(), default_);
    });
  });

  group('clearIfSet', () {
    test('set --> clears', () async {
      await cacheValueWithDefault.set('value');
      await cacheValueWithDefault.clearIfSet();
      expect(cacheValueWithDefault.get(), default_);
    });

    test('not set --> does nothing', () async {
      await cacheValueWithDefault.clearIfSet();
      verifyNever(prefsSpy.remove(any));
    });
  });

  group('setIfChangedOrClearIfSet', () {
    test('null --> clears', () async {
      await cacheValueWithDefault.set('value');
      await cacheValueWithDefault.setIfChangedOrClearIfSet(null);
      expect(cacheValueWithDefault.get(), default_);
    });

    test('not null --> sets', () async {
      await cacheValueWithDefault.setIfChangedOrClearIfSet('value');
      expect(cacheValueWithDefault.get(), 'value');
    });

    test('default --> not set', () async {
      await cacheValueWithDefault.setIfChangedOrClearIfSet(default_);
      verifyNever(prefsSpy.setString(any, any));
    });
  });
}
