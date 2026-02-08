import 'package:flutter_prefs/flutter_prefs_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = PrefsKey.global('key');

  group('withDefault', () {
    test('invalid default --> throws ArgumentError', () async {
      final prefsValueDef = PrefsValueDef.string(key, blacklisted: ['invalid']);
      expect(() => prefsValueDef.withDefault('invalid'), throwsArgumentError);
    });
  });
}
