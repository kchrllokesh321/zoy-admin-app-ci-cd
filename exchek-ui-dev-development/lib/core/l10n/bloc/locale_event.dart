import 'package:exchek/core/utils/exports.dart';

abstract class LocaleEvent {}

class SetLocale extends LocaleEvent {
  final Locale locale;

  SetLocale({required this.locale});
}
