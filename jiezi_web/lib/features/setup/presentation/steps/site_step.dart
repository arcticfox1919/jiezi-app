import 'package:flutter/material.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import '../widgets/setup_widgets.dart';
import 'setup_step.dart';

/// Setup wizard — step 1: site name and optional description.
class SiteStep extends StatefulWidget {
  const SiteStep({super.key});

  @override
  State<SiteStep> createState() => _SiteStepState();
}

class _SiteStepState extends SetupStepState<SiteStep> {
  final _formKey = GlobalKey<FormState>();
  final _siteNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _siteNameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  void contributeData(SetupFormDataBuilder builder) {
    builder.siteName = _siteNameCtrl.text.trim();
    builder.siteDescription = _descriptionCtrl.text.trim().isEmpty
        ? null
        : _descriptionCtrl.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SetupRequiredField(
            controller: _siteNameCtrl,
            label: l10n.siteNameLabel,
            hint: l10n.siteNameHint,
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionCtrl,
            decoration: InputDecoration(
              labelText: l10n.siteDescriptionLabel,
              hintText: l10n.siteDescriptionHint,
              prefixIcon: const Icon(Icons.description_outlined),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
