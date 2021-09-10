import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/create_order_pop_up.dart';
import 'package:bulisa_dashboard/components/delete_pop_up.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/components/filter_order_pop_up.dart';
import 'package:bulisa_dashboard/components/order_detail_pop_up.dart';
import 'package:bulisa_dashboard/components/pagination.dart';
import 'package:bulisa_dashboard/components/table_place_holder.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class OrdersPage extends HookConsumerWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollController = useScrollController();
    final _totalShowData = useState(10);
    final _activePage = useState(0);

    final _orderData = useState<List<Order>>(ref.read(orderProvider));

    final _isLoading = useState(false);

    final _showDetailOrder = useMemoized(
        () => (Order order) async {
              final isEdit = await showDialog(
                context: context,
                builder: (context) => DetailOrderPopUP(order.id),
              );

              if (isEdit == null) {
                return;
              }

              _orderData.value = ref.read(orderProvider);
            },
        []);

    final _createNewOrder = useMemoized(
        () => () async {
              await showDialog(
                context: context,
                builder: (context) => CreateOrderPopUP(),
              );

              _orderData.value = ref.read(orderProvider);
            },
        []);

    final _filterOrderPopUp = useMemoized(
        () => () {
              showDialog(
                context: context,
                builder: (context) => FilterOrderPopUP(),
              );
            },
        []);

    final _deleteOrderPopUp = useMemoized(
        () => (int id) async {
              final isDelete = await showDialog(
                context: context,
                builder: (context) => DeletePopUP(id),
              );

              if (isDelete == null) {
                return;
              }

              _orderData.value = ref.read(orderProvider);
            },
        []);

    useEffect(() {
      _isLoading.value = true;
      ref
          .read(orderProvider.notifier)
          .getOrders(10, 0, ref.read(hasuraClientProvider).state)
          .then((_) {
        _isLoading.value = false;
        _orderData.value = ref.read(orderProvider);
      });

      return;
    }, []);
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
                              onTap: _createNewOrder,
                              text: 'Tambah',
                              leading: Icon(
                                Icons.add_box_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 186,
                            child: FillButton(
                              onTap: _filterOrderPopUp,
                              text: 'Filter Pesanan',
                              color: const Color(0xFFF9F9F9),
                              textColor: const Color(0xFF4A4A4A),
                              leading: Icon(
                                Icons.filter_list_alt,
                                color: const Color(0xFF4A4A4A),
                              ),
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
                                color: Colors.black,
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
                                  label: Text('Nama Pemesan'),
                                ),
                                DataColumn(
                                  label: Text('Total Berat'),
                                ),
                                DataColumn(
                                  label: Text('Alamat'),
                                ),
                                DataColumn(
                                  label: Text('Metode'),
                                ),
                                DataColumn(
                                  label: Text('Tgl. Masuk'),
                                ),
                                DataColumn(
                                  label: Text('Status'),
                                ),
                                DataColumn(
                                  label: Text('Aksi'),
                                ),
                              ],
                              rows: _isLoading.value
                                  ? tablePlaceHolder(7)
                                  : _orderData.value
                                      .map((order) => DataRow(cells: [
                                            DataCell(
                                              Text('${order.orderName}'),
                                            ),
                                            DataCell(
                                              Text('${order.weight}'),
                                            ),
                                            DataCell(
                                              Text('${order.address}'),
                                            ),
                                            DataCell(
                                              Text('${order.method}'),
                                            ),
                                            DataCell(
                                              Text(
                                                  '${DateFormat('dd MMMM yyyy').format(order.createdAt)}'),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 71,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: order.status ==
                                                          'Diproses'
                                                      ? Color(0xFFFDC23A)
                                                      : order.status ==
                                                              'Selesai'
                                                          ? Color(0xFF379B81)
                                                          : Color(0xFFFE685E),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${order.status}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                                        color: const Color(
                                                            0xFFF8A328),
                                                      ),
                                                      color: const Color(
                                                          0x26F8A328),
                                                      onTap: () =>
                                                          _showDetailOrder(
                                                              order),
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
                                                        color: const Color(
                                                            0xFFFE685E),
                                                      ),
                                                      color: const Color(
                                                          0x26FE685E),
                                                      onTap: () =>
                                                          _deleteOrderPopUp(
                                                              order.id),
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
