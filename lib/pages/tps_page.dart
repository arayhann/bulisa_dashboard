import 'package:bulisa_dashboard/components/bordered_text_field.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/components/pagination.dart';
import 'package:bulisa_dashboard/components/tps_detail_pop_up.dart';
import 'package:bulisa_dashboard/components/user_detail_pop_up.dart';
import 'package:bulisa_dashboard/providers/tps.dart';
import 'package:bulisa_dashboard/providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../hasura_config.dart';

class TpsPage extends HookConsumerWidget {
  const TpsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollController = useScrollController();
    final _searchController = useTextEditingController();

    final _usersData = useState<List<Tps>>([]);
    final _filterByName = useState('');

    final _isLoading = useState(true);
    final _isLoadingNewData = useState(false);
    final _isLoadAllData = useState(false);
    final _activePage = useState(0);

    final _showDetailTps = useMemoized(
        () => (Tps tps) async {
              final isEdit = await showDialog(
                context: context,
                builder: (context) => TpsDetailPopUP(tps),
              );

              if (isEdit == null) {
                return;
              }

              _usersData.value = ref.read(tpsDataProvider.notifier).tpsData;
            },
        []);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        if (_activePage.value != 0) {
          _isLoadingNewData.value = true;
          ref
              .read(tpsDataProvider.notifier)
              .getMoreTpsData(
                20,
                _activePage.value,
                ref.read(hasuraClientProvider).state,
                _filterByName.value,
              )
              .then((_) {
            _isLoadingNewData.value = false;

            final loadedData = ref.read(tpsDataProvider.notifier).tpsData;

            if (loadedData.length == _usersData.value.length) {
              _isLoadAllData.value = true;
            } else {
              _usersData.value = loadedData;
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
            .read(tpsDataProvider.notifier)
            .getTpsData(20, 0, ref.read(hasuraClientProvider).state,
                _filterByName.value)
            .then((_) {
          _isLoading.value = false;
          _usersData.value = ref.read(tpsDataProvider.notifier).tpsData;
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
                              hint: 'Cari nomor TPS disini...',
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
                                _isLoadAllData.value = false;
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
                                      Color(0xFF539B9D).withOpacity(0.05)),
                              columns: [
                                DataColumn(
                                  label: Text('Nomor'),
                                ),
                                DataColumn(
                                  label: Text('Nama Pemilik'),
                                ),
                                DataColumn(
                                  label: Text('No. Hp'),
                                ),
                                DataColumn(
                                  label: Text('Status'),
                                ),
                                DataColumn(
                                  label: Text('Alamat'),
                                ),
                                DataColumn(
                                  label: Text('Aksi'),
                                ),
                              ],
                              rows: _isLoading.value
                                  ? tablePlaceHolder()
                                  : [
                                      ..._usersData.value
                                          .map((tps) => DataRow(cells: [
                                                DataCell(
                                                  Text(
                                                    '${tps.id}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    '${tps.tpsOwner}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    '${tps.tpsPhoneNumber ?? '-'}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: tps.status
                                                          ? Color(0xFF539B9D)
                                                          : Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Text(
                                                      '${tps.status ? 'Aktif' : 'Tidak Aktif'}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      '${tps.tpsAddress}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
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
                                                      onTap: () {
                                                        _showDetailTps(tps);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]))
                                          .toList(),
                                      if (_isLoadingNewData.value)
                                        DataRow(cells: [
                                          DataCell(
                                            Shimmer.fromColors(
                                              baseColor:
                                                  const Color(0xFFE3E7EA),
                                              highlightColor:
                                                  const Color(0xFFF5F5F5),
                                              child: Container(
                                                width: 16,
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
      ]),
    ];
  }
}
