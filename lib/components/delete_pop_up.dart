import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drop_down_field.dart';

class DeletePopUP extends HookConsumerWidget {
  final int id;
  const DeletePopUP(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isLoading = useState(false);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Item',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Apakah Anda yakin untuk menghapus Item ini?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FillButton(
                        text: 'Tutup',
                        color: Colors.transparent,
                        textColor: const Color(0xFFFDC639),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: FillButton(
                        text: 'Hapus',
                        leading: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                        isLoading: _isLoading.value,
                        onTap: () async {
                          _isLoading.value = true;

                          await ref.read(orderProvider.notifier).deleteOrder(
                              id, ref.read(hasuraClientProvider).state);

                          _isLoading.value = false;

                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
