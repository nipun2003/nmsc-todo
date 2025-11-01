



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/notifier/register_notifier.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedImage = bytes;
        });
      }
    } catch (e) {
      // ignore errors for now; could show snackbar
    }
  }
  @override
  Widget build(BuildContext context) {

    final notifier = context.watch<RegisterNotifier>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDisabled =
        notifier.isLoading ||
        notifier.emailError != null ||
        notifier.passwordError != null ||
        notifier.nameError != null ||
        notifier.confirmPasswordError != null ||
        _emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty;
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSize.x_8),

            // Image picker in place of AuthLogo
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(AppSize.x_1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: AppSize.x_2,
                    color: Theme.of(context).colorScheme.primary.withAlpha(40),
                  ),
                ),
                child: CircleAvatar(
                  radius: AppSize.x_12_5 / 2,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: _pickedImage == null
                      ? Image.asset(
                          'assets/img/logo.png',
                          width: AppSize.x_8,
                          height: AppSize.x_8,
                          fit: BoxFit.cover,
                        )
                      : ClipOval(
                          child: Image.memory(
                            _pickedImage!,
                            width: AppSize.x_12_5,
                            height: AppSize.x_12_5,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.x_14),
        
            Text("Register", style: textTheme.headlineMedium),
            const SizedBox(height: AppSize.x_8),
        
            // --- Name Field ---
            NmscEtField(
              hintText: "Enter your full name",
              labelText: "Name*",
              controller: _nameController,
              keyboardType: TextInputType.name,
              errorText: notifier.nameError,
              onChanged: notifier.validateName,
            ),
            const SizedBox(height: AppSize.x_5),

            // --- Email Field ---
            NmscEtField(
              hintText: "Enter your email",
              labelText: "Email*",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: notifier.emailError,
              onChanged: notifier.validateEmail,
            ),
            const SizedBox(height: AppSize.x_5),

            // --- Confirm Password Field ---
            NmscEtField(
              hintText: "Password",
              labelText: "Password*",
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscure: true,
              errorText: notifier.passwordError,
              onChanged: (value){
                notifier.validatePassword(value, _confirmPasswordController.text);
              },
            ),
            const SizedBox(height: AppSize.x_4),

            // --- Password Field ---
            NmscEtField(
              hintText: "Re-enter your password",
              labelText: "Confirm Password*",
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscure: true,
              errorText: notifier.confirmPasswordError,
              onChanged: (value) {
                notifier.validateConfirmPassword(value, _passwordController.text);
              },
            ),
            const SizedBox(height: AppSize.x_4),
        
            NmscButton(
              text: "Sign Up",
              fullWidth: true,
              isDisabled: isDisabled,
              isLoading: notifier.isLoading,
              onPressed: () {
                // Handle login action
              },
            ),
            const SizedBox(height: AppSize.x_2),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                NMSCTextButton(text: "Log in", onClick: () {
                  context.pop();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}