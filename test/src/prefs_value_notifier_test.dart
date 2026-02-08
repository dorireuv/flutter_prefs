import 'package:flutter_prefs/flutter_prefs_value.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  const key = PrefsKey.global('key');

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  late PrefsValueNotifier<String> prefsValueNotifier;
  final listener = _Listener();

  setUp(() async {
    await prefs.clear();
    reset(listener);
    prefsValueNotifier = PrefsValueDef.string(key).create(prefs).withNotifier();
    prefsValueNotifier.addListener(listener);
  });

  tearDown(() {
    prefsValueNotifier.removeListener(listener);
  });

  group('set', () {
    test('once -> notify once', () async {
      await prefsValueNotifier.set('value');
      verify(listener()).called(1);
    });

    test('twice -> notify twice', () async {
      await prefsValueNotifier.set('value');
      await prefsValueNotifier.set('value');
      verify(listener()).called(2);
    });
  });

  group('setIfChanged', () {
    test('changed --> notifies', () async {
      await prefsValueNotifier.set('value1');
      reset(listener);

      await prefsValueNotifier.setIfChanged('value2');

      verify(listener()).called(1);
    });

    test('not changed --> does not notify', () async {
      await prefsValueNotifier.set('value');
      reset(listener);

      await prefsValueNotifier.setIfChanged('value');

      verifyNever(listener());
    });
  });

  group('clear', () {
    test('once -> notify once', () async {
      await prefsValueNotifier.clear();
      verify(listener()).called(1);
    });

    test('twice -> notify twice', () async {
      await prefsValueNotifier.clear();
      await prefsValueNotifier.clear();
      verify(listener()).called(2);
    });
  });

  group('clearIfSet', () {
    test('set --> notifies', () async {
      await prefsValueNotifier.set('value');
      reset(listener);

      await prefsValueNotifier.clearIfSet();

      verify(listener()).called(1);
    });

    test('not set --> does not notify', () async {
      await prefsValueNotifier.clearIfSet();
      verifyNever(listener());
    });
  });

  group('setOrClear', () {
    test('notifies', () async {
      await prefsValueNotifier.set('value');
      reset(listener);

      await prefsValueNotifier.setIfChangedOrClearIfSet(null);

      verify(listener()).called(1);
    });
  });
}

class _Listener extends Mock {
  call();
}
