import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drop_down_field.dart';

class DetailOrderPopUP extends HookConsumerWidget {
  final int orderId;
  const DetailOrderPopUP(this.orderId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _status = useState('Diproses');
    final _isPickUp = useState(true);
    final _isLoading = useState(true);
    final _detailedOrder = useState<Order?>(null);

    final _formKey = useState(GlobalKey<FormState>());
    final _isLoadingEdit = useState(false);
    final _orderData = useState<Map<String, dynamic>>({});

    useEffect(() {
      ref
          .read(orderProvider.notifier)
          .getOrderById(
            orderId,
            ref.read(hasuraClientProvider).state,
          )
          .then((order) {
        _isLoading.value = false;
        _detailedOrder.value = order;
        _status.value = order.status;
        _isPickUp.value = order.method == 'Dijemput';
      });
      return;
    }, []);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Form(
        key: _formKey.value,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: _isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detail Pesanan',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 134,
                              width: 134,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _detailedOrder.value!.photoUrl ??
                                        'https://www.unas.ac.id/wp-content/uploads/2021/08/placeholder-29-768x512.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Pemesan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text('${_detailedOrder.value!.orderName}'),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'No Hp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      '${_detailedOrder.value!.orderPhoneNumber}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropDownTextField(
                          listString: [
                            'Diproses',
                            'Selesai',
                            'Ditolak',
                          ],
                          hint: 'Status',
                          value: _status,
                          onSaved: (value) {
                            _orderData.value['status'] = value;
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    initialValue: _detailedOrder.value!.weight,
                                    onSaved: (value) {
                                      _orderData.value['weight'] = value;
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    initialValue: _detailedOrder.value!.price,
                                    onSaved: (value) {
                                      _orderData.value['price'] = value;
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
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
                        IgnorePointer(
                          child: BorderedFormField(
                            hint: 'Alamat',
                            initialValue: _detailedOrder.value!.address,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 136,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: NetworkImage(
                                _detailedOrder.value!.geom == null
                                    ? 'https://www.unas.ac.id/wp-content/uploads/2021/08/placeholder-29-768x512.png'
                                    : 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${_detailedOrder.value!.geom![1]},${_detailedOrder.value!.geom![0]},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
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
                                isLoading: _isLoadingEdit.value,
                                onTap: () async {
                                  _formKey.value.currentState!.save();

                                  _orderData.value['method'] = _isPickUp.value
                                      ? 'Dijemput'
                                      : 'Ditaruh di TPS';

                                  _isLoadingEdit.value = true;

                                  await ref
                                      .read(orderProvider.notifier)
                                      .editOrder(_orderData.value, orderId,
                                          ref.read(hasuraClientProvider).state);

                                  _isLoadingEdit.value = false;
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
      ),
    );
  }
}
