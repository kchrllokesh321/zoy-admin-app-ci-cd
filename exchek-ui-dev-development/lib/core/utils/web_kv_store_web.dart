// Web implementation using sessionStorage
import 'dart:html' as html;

void webKvSetItem(String key, String value) {
  try {
    html.window.sessionStorage[key] = value;
  } catch (_) {}
}

String? webKvGetItem(String key) {
  try {
    return html.window.sessionStorage[key];
  } catch (_) {
    return null;
  }
}

void webKvRemoveItem(String key) {
  try {
    html.window.sessionStorage.remove(key);
  } catch (_) {}
}

void webKvClear() {
  try {
    html.window.sessionStorage.clear();
  } catch (_) {}
}

Set<String> webKvKeys() {
  try {
    return html.window.sessionStorage.keys.toSet();
  } catch (_) {
    return <String>{};
  }
}
