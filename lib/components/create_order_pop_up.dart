import 'package:bulisa_dashboard/components/bordered_button.dart';
import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateOrderPopUP extends HookConsumerWidget {
  const CreateOrderPopUP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useState(GlobalKey<FormState>());
    final _orderData = useState<Map<String, dynamic>>({});
    final _activeIndex = useState(0);
    final _pageViewController = usePageController(keepPage: true);
    final _isPickUp = useState(true);
    final _isLoading = useState(false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Form(
        key: _formKey.value,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tambah Pesanan',
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
                Expanded(
                  child: PageView(
                    controller: _pageViewController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Nama Pemesan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BorderedFormField(
                              hint: 'Masukan nama pemesan',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                              },
                              onSaved: (value) {
                                _orderData.value['order_name'] = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Alamat',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BorderedFormField(
                              hint: 'Alamat',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Alamat tidak boleh kosong';
                                }
                              },
                              onSaved: (value) {
                                _orderData.value['address'] = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Nomor Hp',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BorderedFormField(
                              hint: 'Masukan nomor hp',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nomor HP tidak boleh kosong';
                                }
                              },
                              onSaved: (value) {
                                _orderData.value['order_phone_number'] = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Metode Pangambilan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: true,
                                    groupValue: _isPickUp.value,
                                    title: Text('Dijemput'),
                                    onChanged: (value) {
                                      _isPickUp.value = true;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: false,
                                    groupValue: _isPickUp.value,
                                    title: Text('Ditaruh di TPS'),
                                    onChanged: (value) {
                                      _isPickUp.value = false;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Foto Limbah',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color(0x80505050),
                                ),
                              ),
                              child: Icon(Icons.camera_alt_rounded),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Berat',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      BorderedFormField(
                                        hint: 'Total Berat',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Berat tidak boleh kosong';
                                          }
                                        },
                                        onSaved: (value) {
                                          _orderData.value['weight'] = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Harga',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      BorderedFormField(
                                        hint: 'Total Harga',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Harga tidak boleh kosong';
                                          }
                                        },
                                        onSaved: (value) {
                                          _orderData.value['price'] = value;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: BorderedButton(
                        text: 'Sebelumnya',
                        color: _activeIndex.value == 0
                            ? Color(0x80FDC639)
                            : Color(0xFFFDC639),
                        textColor: _activeIndex.value == 0
                            ? Color(0x80FDC639)
                            : Color(0xFFFDC639),
                        onTap: _activeIndex.value == 0
                            ? null
                            : () {
                                _activeIndex.value--;
                                _pageViewController.animateToPage(
                                  _activeIndex.value,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: _activeIndex.value == 0
                                ? Color(0xFF203288)
                                : Color(0x40203288),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: _activeIndex.value == 1
                                ? Color(0xFF203288)
                                : Color(0x40203288),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      child: FillButton(
                        text: _activeIndex.value == 1
                            ? 'Buat Order'
                            : 'Selanjutnya',
                        isLoading: _isLoading.value,
                        color: Color(0xFFFDC639),
                        onTap: () async {
                          if (!_formKey.value.currentState!.validate()) {
                            return;
                          }

                          _formKey.value.currentState!.save();

                          if (_activeIndex.value == 1) {
                            _orderData.value['status'] = 'Diproses';
                            _orderData.value['method'] =
                                _isPickUp.value ? 'Dijemput' : 'Ditaruh di TPS';

                            _isLoading.value = true;
                            await ref.read(orderProvider.notifier).createOrder(
                                _orderData.value,
                                ref.read(hasuraClientProvider).state);
                            _isLoading.value = false;
                            Navigator.of(context).pop();
                          } else {
                            _activeIndex.value++;
                            _pageViewController.animateToPage(
                              _activeIndex.value,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
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
