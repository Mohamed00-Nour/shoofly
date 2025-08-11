import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.english),
            leading: const Icon(Icons.language),
            trailing: languageProvider.isEnglish 
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              languageProvider.changeLanguage(const Locale('en'));
            },
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.arabic),
            leading: const Icon(Icons.language),
            trailing: languageProvider.isArabic 
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              languageProvider.changeLanguage(const Locale('ar'));
            },
          ),
        ],
      ),
    );
  }
}
