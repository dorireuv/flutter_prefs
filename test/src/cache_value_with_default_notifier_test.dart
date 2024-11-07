import 'package:flutter_cache/src/cache_value.dart';
import 'package:flutter_cache/src/cache_value_def.dart';
import 'package:flutter_cache/src/cache_value_with_default.dart';
import 'package:flutter_cache/src/cache_value_with_default_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  const key = 'key';
  const default_ = 'default';

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  late CacheValueWithDefaultNotifier<String> cacheValueWithDefaultNotifier;
  final listener = _Listener();

  setUp(() async {
    await prefs.clear();
    reset(listener);
    cacheValueWithDefaultNotifier = CacheValueWithDefaultNotifier(
      CacheValueWithDefault(
          cacheValue: CacheValue(prefs: prefs, def: CacheValueDef.string(key)),
          default_: default_),
    );
    cacheValueWithDefaultNotifier.addListener(listener);
  });

  tearDown(() {
    cacheValueWithDefaultNotifier.removeListener(listener);
  });

  group('set', () {
    test('once -> notifies once', () async {
      await cacheValueWithDefaultNotifier.set(default_);
      verify(listener()).called(1);
    });

    test('twice --> notifies twice', () async {
      await cacheValueWithDefaultNotifier.set(default_);
      await cacheValueWithDefaultNotifier.set(default_);
      verify(listener()).called(2);
    });
  });

  group('setIfChanged', () {
    test('not set and default --> does not notify', () async {
      await cacheValueWithDefaultNotifier.setIfChanged(default_);
      verifyNever(listener());
    });

    test('already set and default --> notifies', () async {
      await cacheValueWithDefaultNotifier.set('not default');
      reset(listener);

      await cacheValueWithDefaultNotifier.setIfChanged(default_);

      verify(listener()).called(1);
    });

    test('not changed --> does not notify', () async {
      await cacheValueWithDefaultNotifier.set('value');
      reset(listener);

      await cacheValueWithDefaultNotifier.setIfChanged('value');

      verifyNever(listener());
    });

    test('changed --> notifies', () async {
      await cacheValueWithDefaultNotifier.set('value1');
      reset(listener);

      await cacheValueWithDefaultNotifier.setIfChanged('value2');

      verify(listener()).called(1);
    });
  });

  group('clear', () {
    test('set --> notifies', () async {
      await cacheValueWithDefaultNotifier.set('value');
      reset(listener);

      await cacheValueWithDefaultNotifier.clear();

      verify(listener()).called(1);
    });

    test('not set --> notifies', () async {
      await cacheValueWithDefaultNotifier.clear();
      verify(listener()).called(1);
    });
  });

  group('clearIfSet', () {
    test('set --> notifies', () async {
      await cacheValueWithDefaultNotifier.set('value');
      reset(listener);

      await cacheValueWithDefaultNotifier.clearIfSet();

      verify(listener()).called(1);
    });

    test('not set --> does not notify', () async {
      await cacheValueWithDefaultNotifier.clearIfSet();
      verifyNever(listener());
    });
  });

  group('setIfChangedOrClear', () {
    test('null and set --> notifies', () async {
      await cacheValueWithDefaultNotifier.set('value');
      reset(listener);

      await cacheValueWithDefaultNotifier.setIfChangedOrClearIfSet(null);

      verify(listener()).called(1);
    });

    test('null and not set --> does not notify', () async {
      await cacheValueWithDefaultNotifier.setIfChangedOrClearIfSet(null);
      verifyNever(listener());
    });

    test('not null and changed --> notifies', () async {
      await cacheValueWithDefaultNotifier.setIfChangedOrClearIfSet('value');
      verify(listener()).called(1);
    });

    test('not null and not changed --> does not notify', () async {
      await cacheValueWithDefaultNotifier.set('value');
      reset(listener);

      await cacheValueWithDefaultNotifier.setIfChangedOrClearIfSet('value');

      verifyNever(listener());
    });
  });
}

class _Listener extends Mock {
  call();
}
