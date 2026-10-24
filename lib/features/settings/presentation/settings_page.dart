import 'package:digi_meh/features/settings/presentation/bloc/theme_mode_cubit.dart';
import 'package:digi_meh/features/settings/presentation/widgets/setting_tile.dart';
import 'package:digi_meh/features/settings/presentation/widgets/settings_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  static const String route = "/settings";
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var themeCubit = BlocProvider.of<ThemeModeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          SettingsTitle(title: Text("Appearance")),
          SettingTile(
            leading: const Icon(Icons.format_paint),
            title: Text("Theme Mode", overflow: TextOverflow.ellipsis),
            trailing: FittedBox(
              child: SegmentedButton(
                onSelectionChanged: (newThemeModeSet) {
                  var newThemeMode = newThemeModeSet.first;
                  themeCubit.update(newThemeMode);
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHigh,
                ),
                segments: ThemeMode.values
                    .map(
                      (e) => ButtonSegment(
                        value: e,
                        icon: Icon(switch (e) {
                          ThemeMode.system => Icons.contrast,
                          ThemeMode.light => Icons.light_mode,
                          ThemeMode.dark => Icons.dark_mode,
                        }),
                        tooltip: e.name,
                      ),
                    )
                    .toList(),
                selected: {themeCubit.state},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
