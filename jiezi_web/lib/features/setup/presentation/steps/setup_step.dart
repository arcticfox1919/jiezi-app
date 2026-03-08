import 'package:flutter/material.dart';

import '../../domain/models/setup_form_data.dart';

/// Mutable accumulator written into by each wizard step before final submission.
///
/// Each step owns only the fields it understands; the wizard iterates all steps,
/// calls [SetupStepState.contributeData], then calls [build] once.
final class SetupFormDataBuilder {
  String siteName = '';
  String? siteDescription;
  String adminUsername = '';
  String? adminDisplayName;
  String adminEmail = '';
  String adminPassword = '';
  bool registrationEnabled = false;
  int? maxUploadSizeMb;

  /// Assembles the immutable domain object from the accumulated field values.
  SetupFormData build() => SetupFormData(
    siteName: siteName,
    siteDescription: siteDescription,
    adminUsername: adminUsername,
    adminDisplayName: adminDisplayName,
    adminEmail: adminEmail,
    adminPassword: adminPassword,
    registrationEnabled: registrationEnabled,
    maxUploadSizeMb: maxUploadSizeMb,
  );
}

/// Contract every wizard step state must fulfil.
///
/// Steps are hosted inside an [IndexedStack] in [SetupWizard], which keeps
/// all step widgets mounted and their [State] alive regardless of which step
/// is currently visible.  This means all [TextEditingController]s and local
/// booleans survive back-and-forth navigation without any special restoration.
///
/// ### Adding a new step
/// 1. Create `steps/my_step.dart` with a [StatefulWidget] whose [State]
///    extends [SetupStepState].
/// 2. Override [validate] (delegate to `_formKey.currentState?.validate()`).
/// 3. Override [contributeData] to write owned fields into [builder].
/// 4. In `setup_wizard.dart`, append a [_WizardStepEntry] and the matching
///    widget to `_stepWidgets` — both at the same list index.
/// 5. Add localised label + icon strings to the ARB files and regenerate.
abstract class SetupStepState<T extends StatefulWidget> extends State<T> {
  /// Runs form validation for this step.
  ///
  /// Returns `true` when all required fields pass; field error texts are
  /// shown inline and the wizard stays on this step when `false` is returned.
  bool validate();

  /// Writes this step's field values into [builder].
  ///
  /// Called once per step immediately before the final [SetupFormData] is
  /// submitted.  All steps are always called, even if the user never visited
  /// them (defaults from [SetupFormDataBuilder] apply in that case).
  void contributeData(SetupFormDataBuilder builder);
}
