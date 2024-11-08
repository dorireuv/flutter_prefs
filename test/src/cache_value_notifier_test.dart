import 'package:flutter_cache/src/cache_value.dart';
import 'package:flutter_cache/src/cache_value_defs.dart';
import 'package:flutter_cache/src/cache_value_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  const key = 'key';

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  late CacheValueNotifier<String> cacheValueNotifier;
  final listener = _Listener();

  setUp(() async {
    await prefs.clear();
    reset(listener);
    cacheValueNotifier =
        CacheValueDefs.string(key).create(prefs).withNotifier();
    cacheValueNotifier.addListener(listener);
  });

  tearDown(() {
    cacheValueNotifier.removeListener(listener);
  });

  group('set', () {
    test('once -> notify once', () async {
      await cacheValueNotifier.set('value');
      verify(listener()).called(1);
    });

    test('twice -> notify twice', () async {
      await cacheValueNotifier.set('value');
      await cacheValueNotifier.set('value');
      verify(listener()).called(2);
    });
  });

  group('setIfChanged', () {
    test('changed --> notifies', () async {
      await cacheValueNotifier.set('value1');
      reset(listener);

      await cacheValueNotifier.setIfChanged('value2');

      verify(listener()).called(1);
    });

    test('not changed --> does not notify', () async {
      await cacheValueNotifier.set('value');
      reset(listener);

      await cacheValueNotifier.setIfChanged('value');

      verifyNever(listener());
    });
  });

  group('clear', () {
    test('once -> notify once', () async {
      await cacheValueNotifier.clear();
      verify(listener()).called(1);
    });

    test('twice -> notify twice', () async {
      await cacheValueNotifier.clear();
      await cacheValueNotifier.clear();
      verify(listener()).called(2);
    });
  });

  group('clearIfSet', () {
    test('set --> notifies', () async {
      await cacheValueNotifier.set('value');
      reset(listener);

      await cacheValueNotifier.clearIfSet();

      verify(listener()).called(1);
    });

    test('not set --> does not notify', () async {
      await cacheValueNotifier.clearIfSet();
      verifyNever(listener());
    });
  });

  group('setOrClear', () {
    test('notifies', () async {
      await cacheValueNotifier.set('value');
      reset(listener);

      await cacheValueNotifier.setIfChangedOrClearIfSet(null);

      verify(listener()).called(1);
    });
  });
}

class _Listener extends Mock {
  call();
}
