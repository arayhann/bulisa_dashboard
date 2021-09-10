import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color color;
  final Color textColor;
  final Widget? leading;
  final Widget? child;

  BorderedButton({
    this.text,
    required this.onTap,
    this.leading,
    this.child,
    this.color = const Color(0xFF203288),
    this.textColor = const Color(0xFF203288),
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            side: MaterialStateProperty.resolveWith(
              (states) => BorderSide(color: color, width: 1),
            )),
        onPressed: onTap,
        child: Center(
          child: child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: leading,
                    ),
                  Text(
                    text ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
