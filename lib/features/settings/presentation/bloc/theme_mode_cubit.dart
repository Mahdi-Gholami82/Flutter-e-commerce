import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(super.initialState);

  void update(ThemeMode themeMode) => emit(themeMode);
}
