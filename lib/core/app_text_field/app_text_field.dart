import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.textHint,
    this.icon,
    this.opsCureText,
    this.suffixIcon,
    required this.controller,
    this.validator,
    this.label,
    this.onChanged,
    this.maxLines,
    this.focusNode,
    this.maxLength,
  });

  final TextEditingController controller;
  final String? label;
  final String? textHint;
  final Widget? icon;
  final bool? opsCureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;

  @override
  _AppTextFieldState createState() => _AppTextFieldState(focusNode);
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? focusNode;
  bool _showError = false;

  _AppTextFieldState(this.focusNode);

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    focusNode?.addListener(() {
      if (!focusNode!.hasFocus == false) {
        _showError = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (widget.validator != null) {
          final validationError = widget.validator!(value);
          if (focusNode!.hasFocus) {
            _showError = validationError != null;
          }
          return validationError;
        }
        return null;
      },
      onChanged: widget.onChanged,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: widget.opsCureText ?? false,
      maxLines: widget.maxLines,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[Z0-9 ]')),
        FilteringTextInputFormatter.deny(
          RegExp(r'[ 0]'),
        ),
      ],
      focusNode: focusNode,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.r),
        ),
        label: Text(widget.label ?? ''),
        suffixIcon: widget.suffixIcon,
        fillColor: Colors.white,
        filled: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: _showError ? Colors.red : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        hintText: widget.textHint,
        prefixIcon: widget.icon,
        contentPadding: const EdgeInsetsDirectional.all(15),
        hintStyle: TextStyle(
          color: const Color(0x600B1A51),
          fontSize: 14.sp,
          fontFamily: 'Somar Sans',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
        prefixIconColor: const Color(0xff4051ad29),
      ),
    );
  }
}
