import 'package:exchek/core/utils/exports.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(locale: const Locale('en'))) {
    on<SetLocale>(_onSetLocale);
  }

  void _onSetLocale(SetLocale event, Emitter<LocaleState> emit) {
    emit(state.copyWith(locale: event.locale));
  }
}
