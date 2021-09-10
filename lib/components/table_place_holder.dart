import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

List<DataRow> tablePlaceHolder(int count) {
  return List.generate(10, (index) {
    return DataRow(
        cells: List.generate(count, (index) {
      return DataCell(
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
      );
    }));
  });
}
