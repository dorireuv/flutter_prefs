import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'prefs_spy.mocks.dart';

export 'prefs_spy.mocks.dart';

MockSharedPreferences newPrefsSpy(SharedPreferences prefs) {
  final prefsMock = MockSharedPreferences();
  when(prefsMock.setString(any, any)).thenAnswer((i) =>
      prefs.setString(i.positionalArguments[0], i.positionalArguments[1]));
  when(prefsMock.getString(any))
      .thenAnswer((i) => prefs.getString(i.positionalArguments[0]));
  when(prefsMock.remove(any))
      .thenAnswer((i) => prefs.remove(i.positionalArguments[0]));
  return prefsMock;
}
