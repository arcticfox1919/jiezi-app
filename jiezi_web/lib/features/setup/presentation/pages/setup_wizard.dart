import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import '../providers/setup_providers.dart';
import '../steps/account_step.dart';
import '../steps/advanced_step.dart';
import '../steps/setup_step.dart';
import '../steps/site_step.dart';
import '../widgets/setup_widgets.dart';

// ── Step descriptor ───────────────────────────────────────────────────────────

/// Immutable descriptor for one wizard step.
///
/// Combines the step-indicator metadata (icon, label) with the [GlobalKey]
/// used to reach the step's [SetupStepState] for validation and data
/// collection.  The wizard is intentionally decoupled from each step's
/// concrete [State] type — it only needs the [SetupStepState] contract.
///
/// ### Adding a new step
/// 1. Add a `*Step` widget + `*StepState` in `steps/`.
/// 2. Append a [_WizardStepEntry] in [_SetupWizardState.initState].
/// 3. Append the matching widget (with the entry's [key]) to `_stepWidgets`.
/// 4. Add label + icon strings to the ARB files and regenerate.
final class _WizardStepEntry {
  _WizardStepEntry({required this.icon, required this.labelFn})
      : _key = GlobalKey<SetupStepState>();

  /// Icon shown in the step indicator for upcoming (not-yet-active) steps.
  final IconData icon;

  /// Resolves the localised label shown below the step circle.
  final String Function(AppLocalizations) labelFn;

  final GlobalKey<SetupStepState> _key;

  /// Exposed so the widget tree can attach this key to the step widget.
  GlobalKey<SetupStepState> get key => _key;

  /// Triggers per-step form validation; returns `false` and shows field
  /// errors when validation fails.
  bool validate() => _key.currentState?.validate() ?? false;

  /// Writes this step's field values into [builder].
  void contribute(SetupFormDataBuilder builder) =>
      _key.currentState?.contributeData(builder);
}

// ── Wizard ────────────────────────────────────────────────────────────────────

/// Multi-step setup wizard.
///
/// This widget is the **orchestrator**: it owns the step list, current-step
/// index, and navigation/submission logic.  It knows nothing about individual
/// step fields — all field state lives inside each step widget.
///
/// Steps are hosted in an [IndexedStack] so their [State] (controllers,
/// visibility toggles, etc.) is preserved when the user navigates back.
class SetupWizard extends ConsumerStatefulWidget {
  const SetupWizard({super.key});

  @override
  ConsumerState<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends ConsumerState<SetupWizard> {
  final _currentIndex = ValueNotifier<int>(0);
  late final List<_WizardStepEntry> _steps;

  /// Pre-built widget list kept in the same order as [_steps].
  ///
  /// Stored once so [IndexedStack] reuses the same widget instances across
  /// rebuilds (widgets are not re-created on each [setState]).
  late final List<Widget> _stepWidgets;

  @override
  void initState() {
    super.initState();

    _steps = [
      _WizardStepEntry(
        icon: Icons.language_outlined,
        labelFn: (l10n) => l10n.stepSiteLabel,
      ),
      _WizardStepEntry(
        icon: Icons.shield_outlined,
        labelFn: (l10n) => l10n.stepAccountLabel,
      ),
      _WizardStepEntry(
        icon: Icons.tune_outlined,
        labelFn: (l10n) => l10n.stepAdvancedLabel,
      ),
    ];

    // Must remain in the same order as _steps above.
    _stepWidgets = [
      SiteStep(key: _steps[0].key),
      AccountStep(key: _steps[1].key),
      AdvancedStep(key: _steps[2].key),
    ];
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _next() {
    if (_steps[_currentIndex.value].validate()) {
      _currentIndex.value++;
    }
  }

  void _back() {
    if (_currentIndex.value > 0) _currentIndex.value--;
  }

  /// Collects data from every step and submits.
  Future<void> _submit() async {
    if (!_steps[_currentIndex.value].validate()) return;
    final builder = SetupFormDataBuilder();
    for (final step in _steps) {
      step.contribute(builder);
    }
    await ref.read(setupProvider.notifier).complete(builder.build());
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(setupProvider).isLoading;

    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, currentStep, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SetupStepIndicator(
            currentStep: currentStep,
            stepLabels: _steps.map((s) => s.labelFn(l10n)).toList(),
            stepIcons: _steps.map((s) => s.icon).toList(),
          ),
          const SizedBox(height: 32),
          // IndexedStack keeps all step states alive — navigating back never
          // clears text fields or resets toggles.
          IndexedStack(
            index: currentStep,
            children: _stepWidgets,
          ),
          const SizedBox(height: 28),
          _WizardNavigationRow(
            currentIndex: currentStep,
            totalSteps: _steps.length,
            isLoading: isLoading,
            onBack: _back,
            onNext: _next,
            onSubmit: _submit,
            backLabel: l10n.backButton,
            nextLabel: l10n.nextButton,
            submitLabel: l10n.completeSetupButton,
          ),
        ],
      ),
    );
  }
}

// ── Navigation row ────────────────────────────────────────────────────────────

class _WizardNavigationRow extends StatelessWidget {
  const _WizardNavigationRow({
    required this.currentIndex,
    required this.totalSteps,
    required this.isLoading,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
    required this.backLabel,
    required this.nextLabel,
    required this.submitLabel,
  });

  final int currentIndex;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;
  final String backLabel;
  final String nextLabel;
  final String submitLabel;

  bool get _isLast => currentIndex == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentIndex > 0)
          OutlinedButton(
            onPressed: isLoading ? null : onBack,
            child: Text(backLabel),
          )
        else
          const SizedBox.shrink(),
        if (!_isLast)
          FilledButton(
            onPressed: isLoading ? null : onNext,
            child: Text(nextLabel),
          )
        else
          FilledButton(
            onPressed: isLoading ? null : onSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(submitLabel, style: const TextStyle(fontSize: 16)),
          ),
      ],
    );
  }
}
