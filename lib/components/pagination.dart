import 'package:bulisa_dashboard/components/bordered_button.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Pagination extends HookWidget {
  final int totalPage;
  final ValueNotifier<int> activePage;
  const Pagination(
      {required this.activePage, required this.totalPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: BorderedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text(
                    'Prev',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF203288),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          height: 34,
          child: AnimatedList(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            initialItemCount: 4,
            itemBuilder: (context, index, animation) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: SizedBox(
                width: 34,
                height: 34,
                child: FillButton(
                  text: index == 0
                      ? '1'
                      : index >= 3
                          ? '$totalPage'
                          : '...',
                  color: activePage.value == index
                      ? const Color(0xFF203288)
                      : Colors.transparent,
                  textColor: activePage.value == index
                      ? Colors.white
                      : const Color(0xFF203288),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 84,
          child: BorderedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF203288),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
