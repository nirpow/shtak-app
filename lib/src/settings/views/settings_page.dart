import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoNavigationBarBackButton(
              color: CupertinoColors.white,
              onPressed: () => Navigator.pop(context),
            ),
            automaticallyImplyLeading: true,
            backgroundColor: CupertinoColors.black,
            middle: Text(AppLocalizations.of(context).settings,
                style: const TextStyle(color: Colors.white)),
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
                    header: Text(AppLocalizations.of(context).preferences,
                        style: const TextStyle(color: CupertinoColors.white)),
                    children: [
                      _buildFormRow(
                        AppLocalizations.of(context).language,
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showLanguagePicker(context),
                          child: Text(_languages[state.locale] ?? '',
                              style: const TextStyle(
                                  color: CupertinoColors.activeBlue)),
                        ),
                      ),
                      _buildFormRow(
                        AppLocalizations.of(context).notifications,
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
                    header: Text(AppLocalizations.of(context).support_us,
                        style: const TextStyle(color: CupertinoColors.white)),
                    children: [
                      _buildFormRow(
                        AppLocalizations.of(context).share_app,
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              Share.share('Check out this amazing app!'),
                          child: const Icon(CupertinoIcons.share,
                              color: CupertinoColors.activeBlue),
                        ),
                      ),
                      _buildFormRow(
                        AppLocalizations.of(context).rate_app,
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
                    child: ElevatedButton(
                      onPressed: () => _showResetAlert(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).reset_settings,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
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
        title: Text(AppLocalizations.of(context).reset_settings_popup_title),
        content:
            Text(AppLocalizations.of(context).reset_settings_popup_content),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context).reset),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
