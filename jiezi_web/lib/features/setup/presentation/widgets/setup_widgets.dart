import 'package:flutter/material.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

/// Decorative page header with logo, title and subtitle.
class SetupHeader extends StatelessWidget {
  const SetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.cloud_outlined,
            size: 36,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.setupTitle,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.setupSubtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// A labelled section divider with a leading icon.
class SetupSectionTitle extends StatelessWidget {
  const SetupSectionTitle({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}

/// A [TextFormField] with a required asterisk (*) and a default non-empty
/// validator that uses [requiredMessage] when provided.
class SetupRequiredField extends StatelessWidget {
  const SetupRequiredField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.requiredMessage,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  /// Error text for the default non-empty validator.  Falls back to
  /// [AppLocalizations.fieldRequired] when omitted.
  final String? requiredMessage;

  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (v) => (v == null || v.trim().isEmpty)
              ? (requiredMessage ?? l10n.fieldRequired)
              : null,
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

/// Horizontal step progress indicator for the setup wizard.
///
/// - Completed steps: filled circle with a ✓ mark.
/// - Active step: filled circle with the step number (tells the user "you are
///   on step N").
/// - Upcoming steps: outlined circle with the optional [stepIcons] icon (if
///   provided) or the step number, helping the user understand what's ahead.
class SetupStepIndicator extends StatelessWidget {
  const SetupStepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
    this.stepIcons,
  });

  /// Zero-based index of the currently active step.
  final int currentStep;

  /// Label shown below each step circle.
  final List<String> stepLabels;

  /// Optional icons shown inside upcoming (not-yet-reached) step circles.
  /// When provided, must have the same length as [stepLabels].
  final List<IconData>? stepIcons;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < stepLabels.length; i++) ...[
          _StepCircle(
            index: i,
            currentStep: currentStep,
            label: stepLabels[i],
            icon: stepIcons?.elementAtOrNull(i),
          ),
          if (i < stepLabels.length - 1)
            Expanded(
              child: Padding(
                // Offset so the line is vertically centred with the 32-px circle.
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 2,
                  color: i < currentStep
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.currentStep,
    required this.label,
    this.icon,
  });

  final int index;
  final int currentStep;
  final String label;

  /// Shown inside the circle for upcoming steps (overrides the step number).
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isCompleted = index < currentStep;
    final isActive = index == currentStep;
    final highlighted = isCompleted || isActive;

    final circleColor = highlighted
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final contentColor = highlighted
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;
    final labelColor = highlighted
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final Widget circleContent = switch ((isCompleted, isActive)) {
      // Completed: always show a check mark.
      (true, _) => Icon(Icons.check_rounded, size: 16, color: contentColor),
      // Active: show the step number so the user knows "I am on step N".
      (_, true) => Text(
        '${index + 1}',
        style: TextStyle(
          color: contentColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      // Upcoming: show the step icon (if provided) or fall back to the number.
      _ =>
        icon != null
            ? Icon(icon, size: 16, color: contentColor)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(
              color: highlighted ? colorScheme.primary : colorScheme.outline,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: circleContent,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: labelColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
