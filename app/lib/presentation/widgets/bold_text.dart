import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders text containing `**bold**` and `[label](url)` markers (both used
/// throughout profile.json) as a RichText — bold spans emphasized, links
/// tappable — without pulling in a full markdown package.
class BoldText extends StatelessWidget {
  const BoldText(
    this.data, {
    super.key,
    this.style,
    this.boldStyle,
  });

  final String data;
  final TextStyle? style;
  final TextStyle? boldStyle;

  static final _pattern = RegExp(r'\*\*(.+?)\*\*|\[([^\]]+)\]\(([^)]+)\)');

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final emphasis = boldStyle ??
        baseStyle.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary);
    final linkStyle = baseStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in _pattern.allMatches(data)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: data.substring(cursor, match.start)));
      }
      final boldContent = match.group(1);
      if (boldContent != null) {
        spans.add(TextSpan(text: boldContent, style: emphasis));
      } else {
        final label = match.group(2)!;
        final url = match.group(3)!;
        spans.add(TextSpan(
          text: label,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        ));
      }
      cursor = match.end;
    }
    if (cursor < data.length) {
      spans.add(TextSpan(text: data.substring(cursor)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
