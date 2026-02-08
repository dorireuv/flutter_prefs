import 'package:flutter_prefs/flutter_prefs_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('equals', () {
    test('global equals --> true', () async {
      expect(
          const PrefsKey.global('key') == const PrefsKey.global('key'), isTrue);
    });

    test('global not equals --> false', () async {
      expect(const PrefsKey.global('key1') == const PrefsKey.global('key2'),
          isFalse);
    });

    test('namespaced equals --> true', () async {
      expect(
          const PrefsKey.namespaced('ns', 'key') ==
              const PrefsKey.namespaced('ns', 'key'),
          isTrue);
    });

    test('namespaced with different key --> false', () async {
      expect(
          const PrefsKey.namespaced('ns', 'key1') ==
              const PrefsKey.namespaced('ns', 'key2'),
          isFalse);
    });

    test('namespaced with different namespace --> false', () async {
      expect(
          const PrefsKey.namespaced('ns1', 'key') ==
              const PrefsKey.namespaced('ns2', 'key'),
          isFalse);
    });
  });
}
