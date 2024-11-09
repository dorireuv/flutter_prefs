import 'package:flutter_prefs/flutter_prefs.dart';
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

  late PrefsValueWithDefault<String> prefsValueWithDefault;

  setUp(() async {
    await prefs.clear();
    prefsSpy = newPrefsSpy(prefs);
    prefsValueWithDefault =
        PrefsValueDef.string(key).withDefault(default_).create(prefsSpy);
  });

  group('get', () {
    test('not set --> default', () async {
      expect(prefsValueWithDefault.get(), default_);
    });

    test('set --> value', () async {
      await prefsValueWithDefault.set('value');
      expect(prefsValueWithDefault.get(), 'value');
    });
  });

  group('set', () {
    test('not set and default --> does not set', () async {
      await prefsValueWithDefault.set(default_);
      expect(prefs.getString(key), isNull);
    });

    test('set and default --> clears', () async {
      await prefsValueWithDefault.set('not default');
      await prefsValueWithDefault.set(default_);
      expect(prefs.getString(key), isNull);
    });

    test('not default --> set', () async {
      await prefsValueWithDefault.set('not default');
      expect(prefsValueWithDefault.get(), 'not default');
    });
  });

  group('setIfChanged', () {
    test('not set and default --> does not set', () async {
      await prefsValueWithDefault.setIfChanged(default_);
      expect(prefs.getString(key), isNull);
    });

    test('already set and default --> clears', () async {
      await prefsValueWithDefault.set('not default');
      await prefsValueWithDefault.setIfChanged(default_);
      expect(prefs.getString(key), isNull);
    });

    test('not changed --> not set', () async {
      await prefsValueWithDefault.set('value');
      await prefsValueWithDefault.setIfChanged('value');
      verify(prefsSpy.setString(any, any)).called(1);
    });

    test('changed --> sets', () async {
      await prefsValueWithDefault.set('value1');
      await prefsValueWithDefault.setIfChanged('value2');
      expect(prefsValueWithDefault.get(), 'value2');
    });
  });

  group('clear', () {
    test('set --> clears', () async {
      await prefsValueWithDefault.set('value');
      await prefsValueWithDefault.clear();
      expect(prefsValueWithDefault.get(), default_);
    });

    test('not set --> returns normally', () async {
      await prefsValueWithDefault.clear();
      expect(prefsValueWithDefault.get(), default_);
    });
  });

  group('clearIfSet', () {
    test('set --> clears', () async {
      await prefsValueWithDefault.set('value');
      await prefsValueWithDefault.clearIfSet();
      expect(prefsValueWithDefault.get(), default_);
    });

    test('not set --> does nothing', () async {
      await prefsValueWithDefault.clearIfSet();
      verifyNever(prefsSpy.remove(any));
    });
  });

  group('setIfChangedOrClearIfSet', () {
    test('null --> clears', () async {
      await prefsValueWithDefault.set('value');
      await prefsValueWithDefault.setIfChangedOrClearIfSet(null);
      expect(prefsValueWithDefault.get(), default_);
    });

    test('not null --> sets', () async {
      await prefsValueWithDefault.setIfChangedOrClearIfSet('value');
      expect(prefsValueWithDefault.get(), 'value');
    });

    test('default --> not set', () async {
      await prefsValueWithDefault.setIfChangedOrClearIfSet(default_);
      verifyNever(prefsSpy.setString(any, any));
    });
  });
}
