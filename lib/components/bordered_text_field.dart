import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BorderedFormField extends HookWidget {
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final String? initialValue;
  final int? maxLine;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  BorderedFormField({
    required this.hint,
    this.textEditingController,
    this.initialValue,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.maxLine,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
  });
  @override
  Widget build(BuildContext context) {
    final _labelColor = useState(Color(0xFF505050));
    final _focusNode = useFocusNode();
    useEffect(() {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          _labelColor.value = Color(0xFF203288);
        } else {
          _labelColor.value = Color(0xFF505050);
        }
      });
      return;
    }, []);
    return TextFormField(
      onTap: onTap,
      cursorColor: Color(0xFF203288),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: textEditingController,
      initialValue: initialValue,
      focusNode: _focusNode,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x80505050), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF203288), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            EdgeInsets.only(left: 12, bottom: 12, top: 12, right: 12),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: _labelColor.value,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
