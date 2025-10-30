import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/shapes.dart';
import 'package:nmsc_todo/core/ui/size.dart';

enum TextFieldType { email, password, number, text }

// Keeping FieldState for error and validation status.
class FieldState {
  // Removed final String fieldValue; - Controller now manages the value
  final String? fieldError;
  final bool validating;

  const FieldState({this.fieldError, this.validating = false}); // Updated constructor
}


// ====================================================================
// 3. CUSTOM OUTLINED TEXT FIELD (NmscEtField)
// ====================================================================

class NmscEtField extends StatefulWidget {
  final FieldState state;
  final String hintText;
  final TextFieldType type; // Kept to determine visual transformation (password)

  // NEW: Directly accepting TextEditingController
  final TextEditingController controller;

  // NEW: Directly accepting TextInputType
  final TextInputType keyboardType;

  final bool readOnly;
  final bool isLast;
  final bool requestFocus;
  final String? labelText;

  // Changed to optional, as controller handles value, but can still be used for reactive state
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDoneClick;

  const NmscEtField({
    super.key,
    required this.state,
    required this.hintText,
    required this.controller,
    this.type = TextFieldType.text, // Defaulted type
    this.keyboardType = TextInputType.text, // Defaulted keyboardType
    this.readOnly = false,
    this.isLast = false,
    this.requestFocus = false,
    this.labelText,
    this.onChanged,
    this.onDoneClick,
  });

  @override
  State<NmscEtField> createState() => _NmscEtFieldState();
}

class _NmscEtFieldState extends State<NmscEtField> {
  // Internal state for password visibility
  bool _showPassword = false;
  // FocusNode corresponds to Compose's FocusRequester
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Use addListener on the controller for optional onChanged callback support
    widget.controller.addListener(_handleControllerChange);
    if (widget.requestFocus) {
      // Corresponds to the initial focus request in LaunchedEffect (using safer post-frame approach)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _handleControllerChange() {
    // Manually call onChanged if it was provided
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    _focusNode.dispose();
    super.dispose();
  }

  // Helper to map Compose ImeAction to Flutter's TextInputAction
  TextInputAction _getInputAction(bool isLast) {
    return isLast ? TextInputAction.done : TextInputAction.next;
  }

  // Helper to determine the border color based on state
  Color _getBorderColor(BuildContext context, bool isError, bool isReadOnly) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isError) {
      return colorScheme.error;
    }
    if (isReadOnly) {
      return Colors.transparent;
    }
    // Corresponds to MaterialTheme.colorScheme.outline
    return colorScheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPasswordType = widget.type == TextFieldType.password;

    return Column(
      // modifier = Modifier.fillMaxWidth() -> crossAxisAlignment: CrossAxisAlignment.stretch
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Optional Label
        if (widget.labelText != null) ...[
          // label: Int? -> Text(stringResource(id = label), style = labelMedium)
          Text(
            widget.labelText!,
            style: theme.textTheme.labelMedium,
          ),
          // Spacer(modifier = Modifier.height(x2))
          const SizedBox(height: AppSize.x_2),
        ],

        // 2. Text Field Wrapper (Stack to overlay spinner)
        Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            // Custom Border Container (mimics the .border() modifier)
            Container(
              decoration: BoxDecoration(
                // Assuming MaterialTheme.shapes.medium corresponds to a radius of x4
                borderRadius: AppShapes.large,
                border: Border.all(
                  width: AppSize.x_0_25,
                  color: _getBorderColor(
                    context,
                    widget.state.fieldError != null,
                    widget.readOnly,
                  ),
                ),
              ),
              child: TextFormField(
                // NEW: Use the provided controller
                controller: widget.controller,
                // Changed: onChanged is now handled internally via controller listener

                // .focusRequester(focusRequest)
                focusNode: _focusNode,
                // enabled = !isReadOnly
                enabled: !widget.readOnly,
                // textStyle = MaterialTheme.typography.bodyMedium
                style: theme.textTheme.bodyMedium,
                // singleLine = true, maxLines = 1
                maxLines: 1,

                // keyboardOptions
                // NEW: Use the provided keyboardType
                keyboardType: widget.keyboardType,
                textInputAction: _getInputAction(widget.isLast),

                // keyboardActions (onDone = { onDoneClick() })
                onFieldSubmitted: (String term) {
                  if (widget.isLast) {
                    widget.onDoneClick?.call();
                    _focusNode.unfocus();
                  } else {
                    _focusNode.nextFocus();
                  }
                },

                // isError = state.fieldError != null
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => widget.state.fieldError,

                // visualTransformation
                obscureText: isPasswordType && !_showPassword,

                // Decoration (to hide all Material built-in borders/indicators)
                decoration: InputDecoration(
                  // placeholder = { Text(...) }
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.labelMedium!.copyWith(
                    // color = MaterialTheme.colorScheme.scrim
                    color: theme.colorScheme.scrim,
                  ),

                  // Crucial: Disable all default Material borders
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,

                  // Padding (Adjust to mimic Compose default content padding)
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSize.x_4,
                    vertical: AppSize.x_4,
                  ),

                  // trailingIcon (Visibility Icon)
                  suffixIcon: isPasswordType
                      ? IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: theme.colorScheme.onSurfaceVariant, // Use a subdued color
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  )
                      : null,
                ),
              ),
            ),

            // 3. Validation Spinner
            // if (state.validating) { CircularProgressIndicator(...) }
            if (widget.state.validating)
            // .align(Alignment.CenterEnd) and padding
              Padding(
                // vertical = x3, horizontal = x2
                padding: const EdgeInsets.only(
                    right: AppSize.x_2,
                    top: AppSize.x_3,
                    bottom: AppSize.x_3
                ),
                child: SizedBox(
                  width: AppSize.x_6,
                  height: AppSize.x_6,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
              ),
          ],
        ),

        // 4. Error Message
        // AnimatedVisibility(visible = state.fieldError != null)
        if (widget.state.fieldError != null) ...[
          // Spacer(modifier = Modifier.height(x1))
          const SizedBox(height: AppSize.x_1),
          // Text(text = state.fieldError, style = labelSmall, color = error)
          Text(
            widget.state.fieldError ?? "Please correct this field",
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.start,
          ),
        ]
      ],
    );
  }
}