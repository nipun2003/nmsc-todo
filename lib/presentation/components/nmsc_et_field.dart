import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/shapes.dart';
import 'package:nmsc_todo/core/ui/size.dart';

enum TextFieldType { email, password, number, text }

typedef Validator = String? Function(String? value);

class NmscEtField extends StatefulWidget {
  final String hintText;
  final String? labelText;

  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool readOnly;
  final bool obscure;
  final bool validating;
  final FocusNode? focusNode;

  /// Triggered when user presses "done" or "next"
  final VoidCallback? onSubmitted;

  /// Triggered on every input change
  final ValueChanged<String>? onChanged;

  /// Validation error text to display (optional)
  final String? errorText;

  /// Optional trailing widget (password toggle, clear, spinner, etc.)
  final Widget? suffix;

  const NmscEtField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.obscure = false,
    this.validating = false,
    this.focusNode,
    this.suffix,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<NmscEtField> createState() => _NmscEtFieldState();
}

class _NmscEtFieldState extends State<NmscEtField> {
  late final FocusNode _focusNode;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPasswordType = widget.obscure;
    final hasError = widget.errorText?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: theme.textTheme.labelMedium),
          const SizedBox(height: AppSize.x_2),
        ],

        Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: !widget.readOnly,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: isPasswordType && !_showPassword,
              style: theme.textTheme.bodyMedium,
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmitted?.call(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppShapes.large,
                  borderSide: BorderSide(
                    width: AppSize.x_0_25,
                    color: theme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppShapes.large,
                  borderSide: BorderSide(
                    width: AppSize.x_0_25,
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppShapes.large,
                  borderSide: BorderSide(
                    width: AppSize.x_0_25,
                    color: theme.colorScheme.primary,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppShapes.large,
                  borderSide: BorderSide(
                    width: AppSize.x_0_25,
                    color: theme.colorScheme.error,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSize.x_4,
                  vertical: AppSize.x_4,
                ),
                suffixIcon: widget.validating
                    ? Padding(
                        padding: const EdgeInsets.only(right: AppSize.x_3),
                        child: SizedBox(
                          width: AppSize.x_5,
                          height: AppSize.x_5,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : widget.suffix ??
                        (isPasswordType
                            ? IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () => setState(() {
                                  _showPassword = !_showPassword;
                                }),
                              )
                            : null),
              ),
            ),
          ],
        ),

        // Show error message below
        if (hasError && !widget.validating) ...[
          const SizedBox(height: AppSize.x_1),
          Text(
            widget.errorText!,
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
