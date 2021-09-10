import 'package:flutter/material.dart';

class FillButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color color;
  final Color textColor;
  final Widget? leading;
  final Widget? child;
  final bool isLoading;

  FillButton({
    this.text,
    required this.onTap,
    this.leading,
    this.child,
    this.color = const Color(0xFFFCCB3F),
    this.textColor = Colors.white,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => color,
                ),
              ),
              onPressed: onTap,
              child: child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leading != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: leading,
                        ),
                      (leading != null)
                          ? Text(
                              text ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          : Expanded(
                              child: Text(
                                text ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ],
                  ),
            ),
    );
  }
}
