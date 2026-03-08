import 'package:flutter/material.dart';

/// A small info icon that shows a [Tooltip] with [message] on hover /
/// long-press.
///
/// Use wherever a contextual hint is needed next to a form field or label.
/// Commonly placed in the [InputDecoration.suffixIcon] slot.
///
/// ```dart
/// suffixIcon: TooltipIcon(message: l10n.usernameTooltip),
/// ```
class TooltipIcon extends StatelessWidget {
  const TooltipIcon({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconSize = 18.0,
    this.maxWidth = 280.0,
    this.showDuration = const Duration(seconds: 6),
  });

  /// The text content of the tooltip bubble.
  final String message;

  /// Icon to display; defaults to [Icons.info_outline].
  final IconData icon;

  /// Size of the icon in logical pixels.
  final double iconSize;

  /// Maximum width for the tooltip bubble before text wraps.
  final double maxWidth;

  /// How long the tooltip remains visible after appearing.
  final Duration showDuration;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      constraints: BoxConstraints(maxWidth: maxWidth),
      showDuration: showDuration,
      child: Icon(
        icon,
        size: iconSize,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
