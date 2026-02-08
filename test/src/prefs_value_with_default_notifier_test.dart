import 'package:flutter_prefs/flutter_prefs_value.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  const key = PrefsKey.global('key');
  const default_ = 'default';

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  late PrefsValueWithDefaultNotifier<String> prefsValueWithDefaultNotifier;
  final listener = _Listener();

  setUp(() async {
    await prefs.clear();
    reset(listener);
    prefsValueWithDefaultNotifier = PrefsValueDef.string(key)
        .withDefault(default_)
        .create(prefs)
        .withNotifier();
    prefsValueWithDefaultNotifier.addListener(listener);
  });

  tearDown(() {
    prefsValueWithDefaultNotifier.removeListener(listener);
  });

  group('set', () {
    test('once -> notifies once', () async {
      await prefsValueWithDefaultNotifier.set(default_);
      verify(listener()).called(1);
    });

    test('twice --> notifies twice', () async {
      await prefsValueWithDefaultNotifier.set(default_);
      await prefsValueWithDefaultNotifier.set(default_);
      verify(listener()).called(2);
    });
  });

  group('setIfChanged', () {
    test('not set and default --> does not notify', () async {
      await prefsValueWithDefaultNotifier.setIfChanged(default_);
      verifyNever(listener());
    });

    test('already set and default --> notifies', () async {
      await prefsValueWithDefaultNotifier.set('not default');
      reset(listener);

      await prefsValueWithDefaultNotifier.setIfChanged(default_);

      verify(listener()).called(1);
    });

    test('not changed --> does not notify', () async {
      await prefsValueWithDefaultNotifier.set('value');
      reset(listener);

      await prefsValueWithDefaultNotifier.setIfChanged('value');

      verifyNever(listener());
    });

    test('changed --> notifies', () async {
      await prefsValueWithDefaultNotifier.set('value1');
      reset(listener);

      await prefsValueWithDefaultNotifier.setIfChanged('value2');

      verify(listener()).called(1);
    });
  });

  group('clear', () {
    test('set --> notifies', () async {
      await prefsValueWithDefaultNotifier.set('value');
      reset(listener);

      await prefsValueWithDefaultNotifier.clear();

      verify(listener()).called(1);
    });

    test('not set --> notifies', () async {
      await prefsValueWithDefaultNotifier.clear();
      verify(listener()).called(1);
    });
  });

  group('clearIfSet', () {
    test('set --> notifies', () async {
      await prefsValueWithDefaultNotifier.set('value');
      reset(listener);

      await prefsValueWithDefaultNotifier.clearIfSet();

      verify(listener()).called(1);
    });

    test('not set --> does not notify', () async {
      await prefsValueWithDefaultNotifier.clearIfSet();
      verifyNever(listener());
    });
  });

  group('setIfChangedOrClear', () {
    test('null and set --> notifies', () async {
      await prefsValueWithDefaultNotifier.set('value');
      reset(listener);

      await prefsValueWithDefaultNotifier.setIfChangedOrClearIfSet(null);

      verify(listener()).called(1);
    });

    test('null and not set --> does not notify', () async {
      await prefsValueWithDefaultNotifier.setIfChangedOrClearIfSet(null);
      verifyNever(listener());
    });

    test('not null and changed --> notifies', () async {
      await prefsValueWithDefaultNotifier.setIfChangedOrClearIfSet('value');
      verify(listener()).called(1);
    });

    test('not null and not changed --> does not notify', () async {
      await prefsValueWithDefaultNotifier.set('value');
      reset(listener);

      await prefsValueWithDefaultNotifier.setIfChangedOrClearIfSet('value');

      verifyNever(listener());
    });
  });
}

class _Listener extends Mock {
  call();
}
