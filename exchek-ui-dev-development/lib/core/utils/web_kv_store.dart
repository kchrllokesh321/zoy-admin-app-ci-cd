// Web key-value storage wrapper
// Uses sessionStorage on web; provides a stub on other platforms.

import 'web_kv_store_stub.dart' if (dart.library.html) 'web_kv_store_web.dart' as impl;

Future<void> webKvSetItem(String key, String value) async {
  impl.webKvSetItem(key, value);
}

Future<String?> webKvGetItem(String key) async {
  return impl.webKvGetItem(key);
}

Future<void> webKvRemoveItem(String key) async {
  impl.webKvRemoveItem(key);
}

Future<void> webKvClear() async {
  impl.webKvClear();
}

Future<Set<String>> webKvKeys() async {
  return impl.webKvKeys();
}
