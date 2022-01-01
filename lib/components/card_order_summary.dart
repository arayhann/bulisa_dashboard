import 'package:bulisa_dashboard/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../hasura_config.dart';

class CardOrderSummary extends HookConsumerWidget {
  final int price;
  const CardOrderSummary(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _orderSummaryData = useState<Map<String, int>?>(null);
    final _isLoading = useState(true);

    final _loadingStateText = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE3E7EA),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFE3E7EA),
          ),
        ),
      ),
    );

    useEffect(() {
      // Future.delayed(Duration.zero).then((_) {
      //   _isLoading.value = true;
      //   ref
      //       .read(orderProvider.notifier)
      //       .getOrderSummary(ref.read(hasuraClientProvider).state)
      //       .then((value) {
      //     _isLoading.value = false;
      //     _orderSummaryData.value = value;
      //   });
      // });

      return;
    }, []);

    return SizedBox(
      height: 204,
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F3D5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.opacity,
                      color: const Color(0xFF539B9D),
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoading.value
                          ? _loadingStateText
                          : Text(
                              '${_orderSummaryData.value!['total_weight']}',
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const Text(
                        'Kg Minyak',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F3D5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.people,
                      color: const Color(0xFF539B9D),
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoading.value
                          ? _loadingStateText
                          : Text(
                              '${_orderSummaryData.value!['total_user']}',
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const Text(
                        'Total User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F3D5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.money,
                      color: const Color(0xFF539B9D),
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoading.value
                          ? _loadingStateText
                          : Text(
                              '${(_orderSummaryData.value!['total_weight']! * price / 1000).toStringAsFixed(1)}K',
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const Text(
                        'Uang Ditukar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
