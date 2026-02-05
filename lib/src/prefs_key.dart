import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class PrefsKey {
  const factory PrefsKey.global(String key) = _GlobalPrefsKey;
  const factory PrefsKey.namespaced(String namespace, String key) =
      _NamespacedPrefsKey;

  String get key;

  const PrefsKey._();

  @override
  bool operator ==(Object other) => other is PrefsKey && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'PrefsKey{key: $key}';
}

final class _GlobalPrefsKey extends PrefsKey {
  final String _key;

  const _GlobalPrefsKey(this._key) : super._();

  @override
  String get key => '_global.$_key';
}

final class _NamespacedPrefsKey extends PrefsKey {
  final String _namespace;
  final String _key;

  const _NamespacedPrefsKey(this._namespace, this._key) : super._();

  @override
  String get key => '$_namespace.$_key';
}
