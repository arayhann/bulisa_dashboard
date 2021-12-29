import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool isActive;
  final bool isExpand;
  final AnimationController tabAnimationController;
  final VoidCallback? onPressed;
  const TabButton(
      {required this.icon,
      required this.title,
      required this.isActive,
      required this.isExpand,
      required this.tabAnimationController,
      this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.all(0),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) =>
              isActive ? const Color(0x40E6E3D8) : Colors.transparent),
        ),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
              // border: Border(
              //   left: BorderSide(
              //     color: isActive ? const Color(0xFFFCCB3F) : Colors.transparent,
              //     width: 2,
              //   ),
              // ),
              ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: icon,
              ),
              if (isExpand)
                Expanded(
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: tabAnimationController,
                      curve: Interval(
                        0.5,
                        1,
                        curve: Curves.easeIn,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              isActive ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
