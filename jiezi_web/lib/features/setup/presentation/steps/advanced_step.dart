import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import 'setup_step.dart';

/// Setup wizard — step 3: upload size limit and open-registration policy.
class AdvancedStep extends StatefulWidget {
  const AdvancedStep({super.key});

  @override
  State<AdvancedStep> createState() => _AdvancedStepState();
}

class _AdvancedStepState extends SetupStepState<AdvancedStep> {
  final _formKey = GlobalKey<FormState>();
  final _maxUploadCtrl = TextEditingController(text: '100');
  bool _registrationEnabled = false;

  @override
  void dispose() {
    _maxUploadCtrl.dispose();
    super.dispose();
  }

  @override
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  void contributeData(SetupFormDataBuilder builder) {
    builder.registrationEnabled = _registrationEnabled;
    builder.maxUploadSizeMb = int.tryParse(_maxUploadCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _maxUploadCtrl,
            decoration: InputDecoration(
              labelText: l10n.maxUploadLabel,
              hintText: '100',
              helperText: l10n.maxUploadSubtitle,
              helperMaxLines: 2,
              prefixIcon: const Icon(Icons.upload_file_outlined),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _registrationEnabled,
            onChanged: (v) => setState(() => _registrationEnabled = v),
            title: Text(l10n.publicRegistrationLabel),
            subtitle: Text(l10n.publicRegistrationSubtitle),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
