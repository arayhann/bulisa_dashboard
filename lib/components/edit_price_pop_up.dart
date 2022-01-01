import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drop_down_field.dart';

class EditPricePopUP extends HookConsumerWidget {
  final int initialPrice;
  const EditPricePopUP(this.initialPrice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useState(GlobalKey<FormState>());
    final _newPrice = useState<int?>(null);
    final _isLoading = useState(false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Form(
        key: _formKey.value,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
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
                        'Edit Harga Minya per Kilogram',
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
                    'Harga Minyak per Kilogram',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BorderedFormField(
                    hint: 'Masukkan jumlah harga',
                    initialValue: initialPrice.toString(),
                    onSaved: (value) {
                      if (value != null) {
                        _newPrice.value = int.parse(value);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 87,
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
                      SizedBox(
                        width: 87,
                        child: FillButton(
                          text: 'Perbarui',
                          isLoading: _isLoading.value,
                          onTap: () async {
                            if (!_formKey.value.currentState!.validate()) {
                              return;
                            }

                            _formKey.value.currentState!.save();

                            _isLoading.value = true;

                            await ref
                                .read(orderProvider.notifier)
                                .editOrderPrice(
                                  ref.read(hasuraClientProvider).state,
                                  _newPrice.value!,
                                );

                            _isLoading.value = false;

                            Navigator.of(context).pop(_newPrice.value);
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
      ),
    );
  }
}
