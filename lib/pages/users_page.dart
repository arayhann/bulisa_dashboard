import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/components/pagination.dart';
import 'package:bulisa_dashboard/components/user_detail_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UsersPage extends HookWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = useScrollController();
    final _totalShowData = useState(10);
    final _activePage = useState(0);

    final _usersData = [
      {
        'id': 'lskfnklsfnlskdf',
        'name': 'Gunawan Wibisono',
        'email': 'email@email.com',
        'phone_number': '082123456789',
        'address': 'Jl. Cilaki No. 27',
        'created_at': 'Thu, Jun 04 2021',
      },
      {
        'id': 'lskfnklsfnlskdf',
        'name': 'Gunawan Wibisono',
        'email': 'email@email.com',
        'phone_number': '082123456789',
        'address': 'Jl. Cilaki No. 27',
        'created_at': 'Thu, Jun 04 2021',
      },
      {
        'id': 'lskfnklsfnlskdf',
        'name': 'Gunawan Wibisono',
        'email': 'email@email.com',
        'phone_number': '082123456789',
        'address': 'Jl. Cilaki No. 27',
        'created_at': 'Thu, Jun 04 2021',
      },
    ];

    final _showDetailUser = useMemoized(
        () => (Map<String, Object> user) {
              showDialog(
                context: context,
                builder: (context) => DetailUserPopUP(),
              );
            },
        []);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 138,
                            child: FillButton(
                              onTap: () {},
                              text: 'Tambah',
                              leading: Icon(
                                Icons.add_box_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 311,
                            child: BorderedFormField(
                              prefixIcon: Icon(Icons.search_rounded),
                              hint: 'Cari pesanan disini...',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              dataTextStyle: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF353C48),
                              ),
                              headingRowColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      Color(0xFF203288).withOpacity(0.05)),
                              columns: [
                                DataColumn(
                                  onSort: (columnIndex, ascending) {},
                                  label: Text('Id User'),
                                ),
                                DataColumn(
                                  onSort: (columnIndex, ascending) {},
                                  label: Text('Nama Pemesan'),
                                ),
                                DataColumn(
                                  label: Text('Email'),
                                ),
                                DataColumn(
                                  label: Text('No. Hp'),
                                ),
                                DataColumn(
                                  label: Text('Alamat'),
                                ),
                                DataColumn(
                                  label: Text('Tgl. Masuk'),
                                ),
                                DataColumn(
                                  label: Text('Aksi'),
                                ),
                              ],
                              rows: _usersData
                                  .map((user) => DataRow(cells: [
                                        DataCell(
                                          Text('${user['id']}'),
                                        ),
                                        DataCell(
                                          Text('${user['name']}'),
                                        ),
                                        DataCell(
                                          Text('${user['email']}'),
                                        ),
                                        DataCell(
                                          Text('${user['phone_number']}'),
                                        ),
                                        DataCell(
                                          Text('${user['address']}'),
                                        ),
                                        DataCell(
                                          Text('${user['created_at']}'),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 34,
                                                height: 34,
                                                child: FillButton(
                                                  child: Icon(
                                                    Icons.remove_red_eye,
                                                    color:
                                                        const Color(0xFFF8A328),
                                                  ),
                                                  color:
                                                      const Color(0x26F8A328),
                                                  onTap: () {
                                                    _showDetailUser(user);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 34,
                                                height: 34,
                                                child: FillButton(
                                                  child: Icon(
                                                    Icons.delete,
                                                    color:
                                                        const Color(0xFFFE685E),
                                                  ),
                                                  color:
                                                      const Color(0x26FE685E),
                                                  onTap: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Menampilkan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF353C48),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                height: 36,
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.grey.withOpacity(0.4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: DropdownButton<int>(
                                      value: _totalShowData.value,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_outlined),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF353C48),
                                      ),
                                      underline: SizedBox.shrink(),
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          _totalShowData.value = newValue;
                                        }
                                      },
                                      items: <int>[
                                        5,
                                        10,
                                        15,
                                        20
                                      ].map<DropdownMenuItem<int>>((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text('$value'),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Dari 50 baris',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF353C48),
                                ),
                              ),
                            ],
                          ),
                          Pagination(
                            activePage: _activePage,
                            totalPage: 7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text('© 2021 Bukan Limbah Biasa'),
          ],
        ),
      ),
    );
  }
}
