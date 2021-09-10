import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'drop_down_field.dart';

class FilterOrderPopUP extends HookWidget {
  const FilterOrderPopUP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _status = useState('Diproses');
    final _isPickUp = useState(true);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                      'Filter Pesanan',
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
                  'Nama Pemesan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BorderedFormField(hint: 'Masukkan nama pemesan'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Status Pemesanan',
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
                Text(
                  'Tanggal Masuk',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BorderedFormField(hint: 'Tanggal Masuk'),
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
                        text: 'Filter',
                        onTap: () {},
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
