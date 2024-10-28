import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';

class CustomDropDown extends StatelessWidget {
  final String? value;
  final String label;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final List<DropdownMenuItem<String>> items;
  final Widget? suffixIcon;
  String? hintText;
  TextStyle? style;

  CustomDropDown(
      {super.key,
      required this.value,
      required this.items,
      this.validator,
      this.onChanged,
      required this.label,
      this.suffixIcon,
      this.hintText,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: style ?? getTextTheme().labelMedium,
        ),
        SizedBox(
          height: 10.h,
        ),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items,
          hint: Text(hintText ?? "Please select payment type",
              style: getTextTheme().labelSmall),
          style: getTextTheme().headlineMedium,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(
            fillColor: ConstColors.white,
            counterText: "",
            suffixIcon: suffixIcon,
            labelStyle: getTextTheme().labelMedium,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColors.black),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.sp),
              ),
              borderSide: const BorderSide(
                color: ConstColors.black,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.sp),
              ),
              borderSide: const BorderSide(
                color: ConstColors.red,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.sp),
              ),
              borderSide: const BorderSide(
                color: ConstColors.green,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
