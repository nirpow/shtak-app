import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageChooserDialog extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLanguageChanged;

  const LanguageChooserDialog({
    super.key,
    required this.currentLocale,
    required this.onLanguageChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required Locale currentLocale,
    required Function(Locale) onLanguageChanged,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => LanguageChooserDialog(
        currentLocale: currentLocale,
        onLanguageChanged: onLanguageChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(context, const Locale('en', ''), 'English'),
          _buildLanguageOption(context, const Locale('he', ''), 'Hebrew'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, Locale locale, String title) {
    return RadioListTile<Locale>(
      title: Text(title),
      value: locale,
      groupValue: currentLocale,
      onChanged: (Locale? value) {
        if (value != null) {
          onLanguageChanged(value);
          Navigator.of(context).pop();
        }
      },
    );
  }
}
