import 'package:flutter_prefs/src/prefs_key.dart';
import 'package:flutter_prefs/src/prefs_value.dart';
import 'package:flutter_prefs/src/prefs_value_def.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'prefs_spy.dart';

void main() async {
  const key = PrefsKey.global('key');
  const invalidValue = 'invalid_value';

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  late MockSharedPreferences prefsSpy;

  late PrefsValue<String> prefsValue;

  setUp(() async {
    await prefs.clear();
    prefsSpy = newPrefsSpy(prefs);
    prefsValue =
        PrefsValueDef.string(key, blacklisted: [invalidValue]).create(prefsSpy);
  });

  group('get', () {
    test('not set --> null', () async {
      expect(prefsValue.get(), isNull);
    });

    test('set --> value', () async {
      await prefsValue.set('value');
      expect(prefsValue.get(), 'value');
    });

    test('set with invalid value --> null', () async {
      await prefsValue.set(invalidValue);
      expect(prefsValue.get(), isNull);
    });

    test('set but parser fails --> null', () async {
      await prefsValue.set('not int');
      expect(PrefsValueDef.int_(key).create(prefs).get(), isNull);
    });
  });

  group('getOrDefault', () {
    test('not set --> default', () async {
      expect(prefsValue.getOrDefault('default'), 'default');
    });

    test('set --> value', () async {
      await prefsValue.set('value');
      expect(prefsValue.getOrDefault('default'), 'value');
    });
  });

  group('set', () {
    test('get --> value', () async {
      await prefsValue.set('value');
      expect(prefsValue.get(), 'value');
    });

    test('formats', () async {
      final formattingPrefsValue = PrefsValueDef.value(
        key,
        formatter: (v) => 'formatted $v',
        parser: (v) => v,
      ).create(prefs);
      formattingPrefsValue.set('value');
      expect(prefsValue.get(), 'formatted value');
    });
  });

  group('setIfChanged', () {
    test('changed --> set ', () async {
      await prefsValue.set('value1');
      await prefsValue.setIfChanged('value2');
      verify(prefsSpy.setString(any, any)).called(2);
    });

    test('not changed --> not set', () async {
      await prefsValue.set('value');
      await prefsValue.setIfChanged('value');
      verify(prefsSpy.setString(any, any)).called(1);
    });
  });

  group('clear', () {
    test('set --> clears', () async {
      await prefsValue.set('value');
      await prefsValue.clear();
      expect(prefsValue.get(), isNull);
    });

    test('not set --> returns normally', () async {
      await prefsValue.clear();
      expect(prefsValue.get(), isNull);
    });
  });

  group('clearIfSet', () {
    test('set --> clears', () async {
      await prefsValue.set('value');
      await prefsValue.clearIfSet();
      expect(prefsValue.get(), isNull);
    });

    test('not set --> does nothing', () async {
      await prefsValue.clearIfSet();
      verifyNever(prefsSpy.remove(any));
    });
  });

  group('setIfChangedOrClearIfSet', () {
    test('null --> clears', () async {
      await prefsValue.set('value');
      await prefsValue.setIfChangedOrClearIfSet(null);
      expect(prefsValue.get(), isNull);
    });

    test('not null --> sets', () async {
      await prefsValue.setIfChangedOrClearIfSet('value');
      expect(prefsValue.get(), 'value');
    });
  });
}
