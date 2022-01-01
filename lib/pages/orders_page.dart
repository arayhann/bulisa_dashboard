import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/components/filter_order_pop_up.dart';
import 'package:bulisa_dashboard/components/order_detail_pop_up.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class OrdersPage extends HookConsumerWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollController = useScrollController();
    final _searchController = useTextEditingController();

    final _orderData = useState<List<Order>>([]);
    final _filterByName = useState('');

    final _isLoading = useState(true);
    final _isLoadingNewData = useState(false);
    final _isLoadAllData = useState(false);
    final _activePage = useState(0);

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

    final _filterOrderPopUp = useMemoized(
        () => () {
              showDialog(
                context: context,
                builder: (context) => FilterOrderPopUP(),
              );
            },
        []);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        if (_activePage.value != 0) {
          _isLoadingNewData.value = true;
          ref
              .read(orderProvider.notifier)
              .getMoreOrders(
                20,
                _activePage.value,
                ref.read(hasuraClientProvider).state,
                _filterByName.value,
              )
              .then((_) {
            _isLoadingNewData.value = false;

            final loadedData = ref.read(orderProvider);

            if (loadedData.length == _orderData.value.length) {
              _isLoadAllData.value = true;
            } else {
              _orderData.value = loadedData;
            }
          });
        }
      });

      return;
    }, [_activePage.value, _filterByName.value]);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        _isLoading.value = true;
        ref
            .read(orderProvider.notifier)
            .getOrders(
              20,
              0,
              ref.read(hasuraClientProvider).state,
              _filterByName.value,
            )
            .then((_) {
          _isLoading.value = false;

          final loadedData = ref.read(orderProvider.notifier).orders;
          _orderData.value = loadedData;
        });
      });

      return;
    }, [_filterByName.value]);

    useEffect(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent &&
            !_isLoadingNewData.value) {
          if (!_isLoadAllData.value) {
            _activePage.value++;
          }
        }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 311,
                            child: BorderedFormField(
                              hint: 'Cari nama pemesan disini...',
                              textEditingController: _searchController,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          SizedBox(
                            width: 50,
                            child: FillButton(
                              onTap: () {
                                _activePage.value = 0;
                                _filterByName.value = _searchController.text;
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
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
                                  ? tablePlaceHolder()
                                  : [
                                      ..._orderData.value.map((order) {
                                        return DataRow(cells: [
                                          DataCell(
                                            Text(
                                              '${order.orderName}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${order.weight}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                '${order.address}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${order.method}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${DateFormat('dd MMMM yyyy').format(order.createdAt)}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              width: 71,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: order.status ==
                                                        'Diproses'
                                                    ? Color(0xFFFDC23A)
                                                    : order.status == 'Selesai'
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
                                                    fontWeight: FontWeight.w500,
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
                                                    color:
                                                        const Color(0x26F8A328),
                                                    onTap: () =>
                                                        _showDetailOrder(order),
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   width: 10,
                                                // ),
                                                // SizedBox(
                                                //   width: 34,
                                                //   height: 34,
                                                //   child: FillButton(
                                                //     child: Icon(
                                                //       Icons.delete,
                                                //       color: const Color(
                                                //           0xFFFE685E),
                                                //     ),
                                                //     color: const Color(
                                                //         0x26FE685E),
                                                //     onTap: () =>
                                                //         _deleteOrderPopUp(
                                                //             order.id),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ]);
                                      }).toList(),
                                      if (_isLoadingNewData.value)
                                        DataRow(cells: [
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 80,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFE3E7EA),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text(
                    //             'Menampilkan',
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               color: Color(0xFF353C48),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             width: 12,
                    //           ),
                    //           SizedBox(
                    //             height: 36,
                    //             child: Card(
                    //               elevation: 5,
                    //               shadowColor: Colors.grey.withOpacity(0.4),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 8.0),
                    //                 child: DropdownButton<int>(
                    //                   value: _totalShowData.value,
                    //                   icon: const Icon(
                    //                       Icons.arrow_drop_down_outlined),
                    //                   iconSize: 24,
                    //                   elevation: 16,
                    //                   style: TextStyle(
                    //                     fontSize: 12,
                    //                     color: Color(0xFF353C48),
                    //                   ),
                    //                   underline: SizedBox.shrink(),
                    //                   onChanged: (int? newValue) {
                    //                     if (newValue != null) {
                    //                       _totalShowData.value = newValue;
                    //                     }
                    //                   },
                    //                   items: <int>[
                    //                     5,
                    //                     10,
                    //                     15,
                    //                     20
                    //                   ].map<DropdownMenuItem<int>>((int value) {
                    //                     return DropdownMenuItem<int>(
                    //                       value: value,
                    //                       child: Text('$value'),
                    //                     );
                    //                   }).toList(),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             width: 12,
                    //           ),
                    //           Text(
                    //             'Dari 50 baris',
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               color: Color(0xFF353C48),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Pagination(
                    //         activePage: _activePage,
                    //         totalPage: 7,
                    //       ),
                    //     ],
                    //   ),
                    // ),
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

  List<DataRow> tablePlaceHolder() {
    return [
      DataRow(cells: [
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
      ]),
      DataRow(cells: [
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
      ]),
      DataRow(cells: [
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
        DataCell(
          Shimmer.fromColors(
            baseColor: const Color(0xFFE3E7EA),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFE3E7EA),
              ),
            ),
          ),
        ),
      ]),
    ];
  }
}
