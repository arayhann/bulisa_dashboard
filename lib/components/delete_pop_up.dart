import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bordered_button.dart';
import 'drop_down_field.dart';

class DeletePopUP extends HookConsumerWidget {
  final int id;
  const DeletePopUP(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isLoading = useState(false);
    return AlertDialog(
      title: Text('Hapus Item'),
      content: Text('Apakah Anda yakin untuk menghapus item ini?'),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        Row(
          children: [
            Expanded(
              child: FillButton(
                text: 'Tidak',
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: BorderedButton(
                text: 'Ya',
                color: const Color(0xFFFDC639),
                textColor: const Color(0xFFFDC639),
                leading: Icon(
                  Icons.delete_forever_rounded,
                  color: const Color(0xFFFDC639),
                ),
                onTap: () async {
                  _isLoading.value = true;

                  await ref
                      .read(orderProvider.notifier)
                      .deleteOrder(id, ref.read(hasuraClientProvider).state);

                  _isLoading.value = false;

                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
