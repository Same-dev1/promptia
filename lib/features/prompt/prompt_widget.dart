import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPromptField;
  final String hintText;
  final  StringValidationCallback validatorCallback;
  const PromptInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validatorCallback,
    this.isPromptField = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: isPromptField ? TextInputAction.newline : TextInputAction.next,
      minLines: isPromptField ? 6 : 1,
      maxLines: isPromptField ? 10 : 1,
      maxLength: isPromptField ? 500 : 50,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}