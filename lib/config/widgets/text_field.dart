import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final Function()? onPressed;
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.label,
      this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter a $label";
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
