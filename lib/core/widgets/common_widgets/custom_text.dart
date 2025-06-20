
import '../../base_import.dart';

/// A custom text widgets with default styling and optional overrides.
///
/// This widgets provides a consistent text style across the application,
/// while allowing for customization of properties like [fontSize], [fontWeight],
/// [color], and [textAlign].

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final FontStyle? fontStyle;
  final int? maxLines;
  final TextStyle? textStyle;
  final double? lineSpacing;
  final double? wordSpacing;
  final TextDecoration? decoration;

  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.textStyle,
    this.maxLines,
    this.decoration,
    this.lineSpacing,
    this.wordSpacing,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: textStyle ?? TextStyle(
        color: color,
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: lineSpacing,
        wordSpacing: wordSpacing,
        decoration: decoration,
      ),
    );
  }
}
