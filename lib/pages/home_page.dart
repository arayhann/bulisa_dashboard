import 'package:bulisa_dashboard/components/card_order_summary.dart';
import 'package:bulisa_dashboard/components/edit_price_pop_up.dart';
import 'package:bulisa_dashboard/components/fill_button.dart';
import 'package:bulisa_dashboard/hasura_config.dart';
import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isLoading = useState(false);
    final _price = useState(0);
    final _editPricePopUp = useMemoized(
        () => () async {
              final newPrice = await showDialog(
                context: context,
                builder: (context) => EditPricePopUP(_price.value),
              );

              if (newPrice == null) {
                return;
              }

              _price.value = newPrice;
            },
        []);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        _isLoading.value = true;
        ref
            .read(orderProvider.notifier)
            .getOrderPrice(ref.read(hasuraClientProvider).state)
            .then((value) {
          _isLoading.value = false;
          _price.value = value;
        });
      });

      return;
    }, []);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0x80C4C4C4),
                  image: DecorationImage(
                    image: AssetImage("assets/img-bg-home.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(27),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bulisa',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Layanan Koleksi Limbah Minyak Bekas',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CardOrderSummary(_price.value),
              const SizedBox(
                height: 12,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: SizedBox(
              //         height: 404,
              //         child: Card(
              //           elevation: 5,
              //           shadowColor: Colors.grey.withOpacity(0.2),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(16),
              //           ),
              //           child: Padding(
              //               padding: const EdgeInsets.all(20),
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Text(
              //                         'Total Kg Minyak (Liter)',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                       Text(
              //                         '120',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   const SizedBox(
              //                     height: 20,
              //                   ),
              //                   Expanded(
              //                     child: LineChart(LineChartData(
              //                       gridData: FlGridData(
              //                         show: true,
              //                         drawVerticalLine: true,
              //                         getDrawingHorizontalLine: (value) {
              //                           return FlLine(
              //                             color: const Color(0xff37434d),
              //                             strokeWidth: 1,
              //                           );
              //                         },
              //                         getDrawingVerticalLine: (value) {
              //                           return FlLine(
              //                             color: const Color(0xff37434d),
              //                             strokeWidth: 1,
              //                           );
              //                         },
              //                       ),
              //                       titlesData: FlTitlesData(
              //                         show: true,
              //                         bottomTitles: SideTitles(
              //                           showTitles: true,
              //                           reservedSize: 22,
              //                           getTextStyles: (context, value) =>
              //                               const TextStyle(
              //                                   color: Color(0xff68737d),
              //                                   fontWeight: FontWeight.bold,
              //                                   fontSize: 16),
              //                           getTitles: (value) {
              //                             switch (value.toInt()) {
              //                               case 2:
              //                                 return 'MAR';
              //                               case 5:
              //                                 return 'JUN';
              //                               case 8:
              //                                 return 'SEP';
              //                             }
              //                             return '';
              //                           },
              //                           margin: 8,
              //                         ),
              //                         leftTitles: SideTitles(
              //                           showTitles: true,
              //                           getTextStyles: (context, value) =>
              //                               const TextStyle(
              //                             color: Color(0xff67727d),
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 15,
              //                           ),
              //                           getTitles: (value) {
              //                             switch (value.toInt()) {
              //                               case 1:
              //                                 return '10L';
              //                               case 3:
              //                                 return '20L';
              //                               case 5:
              //                                 return '30L';
              //                             }
              //                             return '';
              //                           },
              //                           reservedSize: 28,
              //                           margin: 12,
              //                         ),
              //                       ),
              //                       borderData: FlBorderData(
              //                           show: true,
              //                           border: Border.all(
              //                               color: const Color(0xff37434d),
              //                               width: 1)),
              //                       minX: 0,
              //                       maxX: 11,
              //                       minY: 0,
              //                       maxY: 6,
              //                       lineBarsData: [
              //                         LineChartBarData(
              //                           spots: [
              //                             FlSpot(0, 3),
              //                             FlSpot(2.6, 2),
              //                             FlSpot(4.9, 5),
              //                             FlSpot(6.8, 3.1),
              //                             FlSpot(8, 4),
              //                             FlSpot(9.5, 3),
              //                             FlSpot(11, 4),
              //                           ],
              //                           isCurved: true,
              //                           colors: [
              //                             const Color(0xff23b6e6),
              //                             const Color(0xff02d39a),
              //                           ],
              //                           barWidth: 5,
              //                           isStrokeCapRound: true,
              //                           dotData: FlDotData(
              //                             show: false,
              //                           ),
              //                           belowBarData: BarAreaData(
              //                             show: true,
              //                             colors: [
              //                               const Color(0xff23b6e6),
              //                               const Color(0xff02d39a),
              //                             ]
              //                                 .map((color) =>
              //                                     color.withOpacity(0.3))
              //                                 .toList(),
              //                           ),
              //                         ),
              //                       ],
              //                     )),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 12,
              //     ),
              //     Expanded(
              //       child: SizedBox(
              //         height: 404,
              //         child: Card(
              //           elevation: 5,
              //           shadowColor: Colors.grey.withOpacity(0.2),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(16),
              //           ),
              //           child: Padding(
              //               padding: const EdgeInsets.all(20),
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Text(
              //                         'Total Uang ditukar (Rp.)',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                       Text(
              //                         '120k',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   const SizedBox(
              //                     height: 20,
              //                   ),
              //                   Expanded(
              //                     child: LineChart(LineChartData(
              //                       gridData: FlGridData(
              //                         show: true,
              //                         drawVerticalLine: true,
              //                         getDrawingHorizontalLine: (value) {
              //                           return FlLine(
              //                             color: const Color(0xff37434d),
              //                             strokeWidth: 1,
              //                           );
              //                         },
              //                         getDrawingVerticalLine: (value) {
              //                           return FlLine(
              //                             color: const Color(0xff37434d),
              //                             strokeWidth: 1,
              //                           );
              //                         },
              //                       ),
              //                       titlesData: FlTitlesData(
              //                         show: true,
              //                         bottomTitles: SideTitles(
              //                           showTitles: true,
              //                           reservedSize: 22,
              //                           getTextStyles: (context, value) =>
              //                               const TextStyle(
              //                                   color: Color(0xff68737d),
              //                                   fontWeight: FontWeight.bold,
              //                                   fontSize: 16),
              //                           getTitles: (value) {
              //                             switch (value.toInt()) {
              //                               case 2:
              //                                 return 'MAR';
              //                               case 5:
              //                                 return 'JUN';
              //                               case 8:
              //                                 return 'SEP';
              //                             }
              //                             return '';
              //                           },
              //                           margin: 8,
              //                         ),
              //                         leftTitles: SideTitles(
              //                           showTitles: true,
              //                           getTextStyles: (context, value) =>
              //                               const TextStyle(
              //                             color: Color(0xff67727d),
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 15,
              //                           ),
              //                           getTitles: (value) {
              //                             switch (value.toInt()) {
              //                               case 1:
              //                                 return '100k';
              //                               case 3:
              //                                 return '200k';
              //                               case 5:
              //                                 return '300k';
              //                             }
              //                             return '';
              //                           },
              //                           reservedSize: 28,
              //                           margin: 12,
              //                         ),
              //                       ),
              //                       borderData: FlBorderData(
              //                           show: true,
              //                           border: Border.all(
              //                               color: const Color(0xff37434d),
              //                               width: 1)),
              //                       minX: 0,
              //                       maxX: 11,
              //                       minY: 0,
              //                       maxY: 6,
              //                       lineBarsData: [
              //                         LineChartBarData(
              //                           spots: [
              //                             FlSpot(0, 3),
              //                             FlSpot(2.6, 2),
              //                             FlSpot(4.9, 5),
              //                             FlSpot(6.8, 3.1),
              //                             FlSpot(8, 4),
              //                             FlSpot(9.5, 3),
              //                             FlSpot(11, 4),
              //                           ],
              //                           isCurved: true,
              //                           colors: [
              //                             const Color(0xff23b6e6),
              //                             const Color(0xff02d39a),
              //                           ],
              //                           barWidth: 5,
              //                           isStrokeCapRound: true,
              //                           dotData: FlDotData(
              //                             show: false,
              //                           ),
              //                           belowBarData: BarAreaData(
              //                             show: true,
              //                             colors: [
              //                               const Color(0xff23b6e6),
              //                               const Color(0xff02d39a),
              //                             ]
              //                                 .map((color) =>
              //                                     color.withOpacity(0.3))
              //                                 .toList(),
              //                           ),
              //                         ),
              //                       ],
              //                     )),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              SizedBox(
                height: 204,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                          child: FillButton(
                            onTap: _editPricePopUp,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '1 kg Minyak',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '=',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Rp. ${_price.value}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text('© 2021 Bukan Limbah Biasa')
            ],
          ),
        ),
      ),
    );
  }
}
