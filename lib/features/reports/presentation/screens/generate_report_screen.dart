import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/widgets/custom_app_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_date_picker_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/controllers/user_controller.dart';
import '../../controllers/generate_report_controller.dart';

class GenerateReportScreen extends GetView<GenerateReportController> {
  const GenerateReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.generateReport, 
        showBackButton: false,
      ),
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadReports,
          child: Column(
            children: [

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report Type Section
                      Text(
                        AppStrings.reportType,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          letterSpacing: 1.2,
                        ).copyWith(textBaseline: TextBaseline.alphabetic),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedReportType.value.isEmpty ? null : controller.selectedReportType.value,
                        decoration: InputDecoration(
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
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: TextStyle(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontSize: 16,
                        ),
                        dropdownColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                        items: controller.reportTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: controller.updateSelectedReportType,
                        hint: Text(
                          AppStrings.weeklyStockActivityReport,
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      )),

                      const SizedBox(height: 24),

                      // Date Range Section
                      Text(
                        AppStrings.dateRange,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Start Date
                          Expanded(
                            child: CustomDatePickerField(
                              label: AppStrings.startDate,
                              controller: controller.startDateController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // End Date
                          Expanded(
                            child: CustomDatePickerField(
                              label: AppStrings.endDate,
                              controller: controller.endDateController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Filters Section
                      Text(
                        AppStrings.filtersOptional,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Part Name Filter
                      CustomDropdown(
                        label: AppStrings.partName,
                        value: controller.selectedPartName.value,
                        items: controller.partNames,
                        onChanged: controller.updateSelectedPartName,
                      ),
                      const SizedBox(height: 16),
                      // Technician Name Filter - Only show for admins
                      if (userController.isAdmin)
                        CustomTextField(
                          label: AppStrings.technicianName,
                          hint: 'e.g. John Doe',
                          controller: controller.technicianNameController,
                        ),

                      const SizedBox(height: 32),

                      // Illustration area
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.description,
                                size: 48,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.reportDescription,
                                style: TextStyle(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80), // Space for bottom button
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark.withOpacity(0.8) : AppColors.backgroundLight.withOpacity(0.8),
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderDark.withOpacity(0.3) : AppColors.borderLight.withOpacity(0.3),
                    ),
                  ),
                ),
                child: CustomElevatedButton(
                  buttonName: AppStrings.generateReportButton,
                  buttonIcon: Icons.analytics,
                  onPressed: controller.generateReport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
