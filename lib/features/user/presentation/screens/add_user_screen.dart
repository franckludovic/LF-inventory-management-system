import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../controllers/add_user_controller.dart';

class AddUserScreen extends GetView<AddUserController> {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.addTechnician,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Field
            _buildFormField(
              label: AppStrings.fullName,
              controller: controller.fullNameController,
              hintText: AppStrings.enterTechniciansFullName,
              errorText: controller.fullNameError,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildFormField(
              label: AppStrings.emailLabel,
              controller: controller.emailController,
              hintText: AppStrings.enterEmail,
              errorText: controller.emailError,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // Department Field
            _buildFormField(
              label: AppStrings.departmentLabel,
              controller: controller.departmentController,
              hintText: AppStrings.enterDepartment,
              errorText: controller.departmentError,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // Region Field
            _buildFormField(
              label: AppStrings.regionLabel,
              controller: controller.regionController,
              hintText: AppStrings.enterRegion,
              errorText: controller.regionError,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // Ville Field
            _buildFormField(
              label: AppStrings.villeLabel,
              controller: controller.villeController,
              hintText: AppStrings.enterVille,
              errorText: controller.villeError,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // Temporary Password Field
            _buildPasswordField(isDark),
            const SizedBox(height: 16),

            // Role Field
            _buildRoleDropdown(isDark),
            const SizedBox(height: 16),

            // Block/Unblock User (only in edit mode)
            if (controller.isEditing.value) _buildBlockUnblockToggle(isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(isDark),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required RxString errorText,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText.value.isNotEmpty
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText.value.isNotEmpty
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText.value.isNotEmpty ? AppColors.error : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        )),
        Obx(() => errorText.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorText.value,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.temporaryPassword,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.setTemporaryPassword,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: controller.passwordError.value.isNotEmpty
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: controller.passwordError.value.isNotEmpty
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: controller.passwordError.value.isNotEmpty ? AppColors.error : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        )),
        const SizedBox(height: 4),
        Text(
          AppStrings.passwordHint,
          style: TextStyle(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontSize: 12,
          ),
        ),
        Obx(() => controller.passwordError.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  controller.passwordError.value,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildRoleDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.role,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: controller.selectedRole.value,
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 16,
            ),
            dropdownColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            items: [
              DropdownMenuItem(
                value: 'Technician',
                child: Text(AppStrings.technicianRole),
              ),
              DropdownMenuItem(
                value: 'Admin',
                child: Text(AppStrings.adminRole),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                controller.selectedRole.value = value;
              }
            },
          ),
        )),
      ],
    );
  }

  Widget _buildBlockUnblockToggle(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statue du Compte',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bloquer l\'Utilisateur',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 16,
                ),
              ),
              Obx(() => Switch(
                value: controller.isUserBlocked.value,
                onChanged: (value) {
                  controller.isUserBlocked.value = value;
                },
                activeColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withOpacity(0.3),
              )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Note: Block/Unblock functionality is not yet implemented in the backend.',
          style: TextStyle(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => ElevatedButton.icon(
            onPressed: controller.isFormValid.value ? controller.onSaveUser : null,
            icon: const Icon(Icons.person_add, size: 20),
            label: Text(controller.isEditing.value ? 'Update User' : AppStrings.saveTechnician),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isFormValid.value ? AppColors.primary : AppColors.textMutedLight,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: controller.isFormValid.value ? 2 : 0,
              shadowColor: controller.isFormValid.value ? AppColors.shadowPrimary : null,
            ),
          )),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
