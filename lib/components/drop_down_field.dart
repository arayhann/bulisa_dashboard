import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DropDownTextField extends HookWidget {
  final ValueNotifier<String> value;
  final String hint;
  final List<String> listString;
  final Function(String?)? onSaved;
  final String Function(String?)? validator;

  DropDownTextField({
    required this.value,
    required this.hint,
    required this.listString,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Biennale',
              fontWeight: FontWeight.w500,
              color: Colors.black),
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0x80505050)),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                EdgeInsets.only(left: 16, bottom: 8, top: 8, right: 16),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
          ),
          value: value.value,
          iconSize: 24,
          elevation: 16,
          onChanged: (String? newValue) {
            if (newValue != null) {
              value.value = newValue;
            }
          },
          validator: validator,
          items: listString.isEmpty
              ? null
              : listString.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Color(0xFF585858)),
                      ),
                    );
                  },
                ).toList(),
          onSaved: onSaved,
        ),
      ),
    );
  }
}
