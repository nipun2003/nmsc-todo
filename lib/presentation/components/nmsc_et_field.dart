import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';

class NmscEtField extends StatelessWidget {
  final String? label;
  final String? value;
  final TextEditingController? controller;
  final TextInputType type;
  final bool isLast;
  final bool isPassword;
  final bool isSearch;
  final VoidCallback? onDoneClick;
  final VoidCallback? onSearchClick;
  final String? hintText;

  const NmscEtField({
    super.key,
    this.label,
    this.value,
    this.controller,
    this.type = TextInputType.text,
    this.isLast = false,
    this.isPassword = false,
    this.isSearch = false,
    this.onDoneClick,
    this.onSearchClick,
    this.hintText,
  });

  // Helper method to determine the keyboard action
  TextInputAction _getInputAction() {
    if (isLast) {
      return TextInputAction.done;
    } else if (isSearch) {
      return TextInputAction.search;
    }
    return TextInputAction.next;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // The Column must take full width to ensure the TextField is full width
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Keep column size minimal vertically
      children: [
        // 1. Label
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label!, style: Theme.of(context).textTheme.labelMedium),
          ),

        // 2. Text Field
        TextFormField(
          initialValue: value,
          controller: controller,
          keyboardType: type,
          obscureText: isPassword,
          textInputAction: _getInputAction(),
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.x_2)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSize.x_3,
              vertical: AppSize.x_2,
            ),
          ),

          // Logic for keyboard action
          onFieldSubmitted: (String term) {
            final inputAction = _getInputAction();

            if (inputAction == TextInputAction.done) {
              // Call the done callback if it's the last field
              onDoneClick?.call();
            } else if (inputAction == TextInputAction.search) {
              // Call the search callback if it's a search field
              onSearchClick?.call();
            } else if (inputAction == TextInputAction.next) {
              // Move focus to the next field (default behavior)
              FocusScope.of(context).nextFocus();
            }
            // For search, usually no specific focus movement is needed after submission
          },
        ),
      ],
    );
  }
}
