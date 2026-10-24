import 'package:digi_meh/core/data/repositories/preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(super.initialState);

  void update(ThemeMode themeMode) => emit(themeMode);

  @override
  void onChange(Change<ThemeMode> change) {
    super.onChange(change);
    GetIt.instance<PreferencesRepository>().saveThemeMode(change.nextState);
  }
}
