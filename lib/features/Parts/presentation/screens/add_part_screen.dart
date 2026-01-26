import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../controllers/add_part_controller.dart';

class AddPartScreen extends GetView<AddPartController> {
  const AddPartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppStrings.addNewSparePart,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Part Name Field
                  _buildTextField(
                    label: AppStrings.partNameLabel,
                    hint: AppStrings.partNameHint,
                    controller: controller.partNameController,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Designation/Reference Field
                  _buildTextField(
                    label: AppStrings.designationReference,
                    hint: AppStrings.designationHint,
                    controller: controller.designationController,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Manufacturer Field
                  _buildTextField(
                    label: AppStrings.manufacturer,
                    hint: AppStrings.manufacturerHint,
                    controller: controller.manufacturerController,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Description Field
                  _buildTextAreaField(
                    label: AppStrings.descriptionOptional,
                    hint: AppStrings.descriptionHint,
                    controller: controller.descriptionController,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Quantity and Location Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: AppStrings.initialQuantity,
                          controller: controller.quantityController,
                          keyboardType: TextInputType.number,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoadingLocations.value) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              // Force rebuild or focus
                            },
                            child: _buildDropdownField(
                              label: AppStrings.bagLocation,
                              hint: AppStrings.selectLocation,
                              items: controller.availableLocations.isEmpty ? ['No locations available'] : controller.availableLocations,
                              selectedValue: controller.selectedLocation.value.isEmpty ? null : controller.selectedLocation.value,
                              onChanged: controller.onLocationSelected,
                              isDark: isDark,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Part Photo Section
                  Text(
                    AppStrings.partPhoto,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Image Upload Area
                  Obx(() {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
                          width: 2,
                        ),
                      ),
                      child: controller.selectedImagePath.value.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(controller.selectedImagePath.value),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 48,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.captureOrUploadImage,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                                Text(
                                  AppStrings.maxSize5MB,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Upload Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: AppStrings.upload,
                          icon: Icons.upload,
                          onPressed: controller.onUploadPressed,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          label: AppStrings.camera,
                          icon: Icons.photo_camera,
                          onPressed: controller.onCameraPressed,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
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
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: controller.onCancelPressed,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppStrings.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.onSavePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppStrings.savePart,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textSecondaryDark.withOpacity(0.6) : AppColors.textSecondaryLight.withOpacity(0.6),
            ),
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required TextEditingController controller,
    String? hint,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 4,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textSecondaryDark.withOpacity(0.6) : AppColors.textSecondaryLight.withOpacity(0.6),
            ),
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue?.isNotEmpty == true ? selectedValue : null,
              hint: Text(
                hint,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark.withOpacity(0.6) : AppColors.textSecondaryLight.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              isExpanded: true,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue!);
                }
              },
              icon: Icon(
                Icons.unfold_more,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              dropdownColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: AppColors.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? AppColors.cardBackgroundLight.withOpacity(0.1) : AppColors.cardBackgroundDark.withOpacity(0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
    );
  }
}
