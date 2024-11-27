import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shtak/src/settings/cubit/settings_cubit.dart';
import 'package:shtak/src/settings/cubit/settings_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  final Map<Locale, String> _languages = {
    const Locale('en'): 'English',
    const Locale('he'): 'עברית',
  };

  void _handleLanguageChange(int index) {
    List<Locale> langList = _languages.keys.toList();
    context.read<SettingsCubit>().updateLanguage(langList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: const CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            backgroundColor: CupertinoColors.black,
            middle: Text('Settings',
                style: TextStyle(color: CupertinoColors.white)),
          ),
          child: SafeArea(
            child: CupertinoScrollbar(
              child: ListView(
                children: [
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: CupertinoColors.black,
                    decoration: BoxDecoration(
                      color: CupertinoColors.darkBackgroundGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    header: const Text('Preferences',
                        style: TextStyle(color: CupertinoColors.white)),
                    children: [
                      _buildFormRow(
                        'Language',
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showLanguagePicker(context),
                          child: Text(_languages[state.locale] ?? '',
                              style: const TextStyle(
                                  color: CupertinoColors.activeBlue)),
                        ),
                      ),
                      _buildFormRow(
                        'Notifications',
                        CupertinoSwitch(
                          value: _notificationsEnabled,
                          onChanged: (value) =>
                              setState(() => _notificationsEnabled = value),
                        ),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: CupertinoColors.black,
                    decoration: BoxDecoration(
                      color: CupertinoColors.darkBackgroundGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    header: const Text('Support',
                        style: TextStyle(color: CupertinoColors.white)),
                    children: [
                      _buildFormRow(
                        'Share App',
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              Share.share('Check out this amazing app!'),
                          child: const Icon(CupertinoIcons.share,
                              color: CupertinoColors.activeBlue),
                        ),
                      ),
                      _buildFormRow(
                        'Rate App',
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => launchUrl(
                            Uri.parse('https://apps.apple.com/app/your-app-id'),
                            mode: LaunchMode.externalApplication,
                          ),
                          child: const Icon(CupertinoIcons.star,
                              color: CupertinoColors.activeBlue),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoButton.filled(
                      onPressed: () => _showResetAlert(context),
                      child: Text(
                        AppLocalizations.of(context).reset_settings,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormRow(String label, Widget trailing) {
    return CupertinoFormRow(
      prefix: Text(label, style: const TextStyle(color: CupertinoColors.white)),
      child: trailing,
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216,
        color: CupertinoColors.darkBackgroundGray,
        child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) {
              _handleLanguageChange(index);
            },
            children: _languages.values
                .map((language) => Text(language,
                    style: const TextStyle(color: CupertinoColors.white)))
                .toList()),
      ),
    );
  }

  void _showResetAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text('This will restore default settings.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Reset'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
