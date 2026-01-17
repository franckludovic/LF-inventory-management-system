import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/constants/strings.dart';
import '../controllers/login_controller.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/login_button.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const BrandHeader(),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    CustomTextField(
                      label: AppStrings.username,
                      hint: AppStrings.enterYourIdOrEmail,
                      controller: controller.usernameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: AppStrings.password,
                      hint: AppStrings.enterYourPassword,
                      isPassword: true,
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 24),
                    Obx(() => LoginButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        controller.handleLogin();
                      },
                      isLoading: controller.isLoading.value,
                    )),


                    Obx(() => controller.errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
