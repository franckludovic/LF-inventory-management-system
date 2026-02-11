import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/widgets/custom_app_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_date_picker_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
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
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            /// MAIN CONTENT
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadReports,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// REPORT TYPE
                      Text(
                        AppStrings.reportType,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Obx(() => DropdownButtonFormField<String>(
                            value: controller
                                    .selectedReportType.value.isEmpty
                                ? null
                                : controller.selectedReportType.value,
                            isExpanded: true,
                            decoration: _inputDecoration(isDark),
                            dropdownColor: isDark
                                ? AppColors.cardBackgroundDark
                                : AppColors.cardBackgroundLight,
                            items: controller.reportTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged:
                                controller.updateSelectedReportType,
                            hint: Text(
                              AppStrings.selectReportType,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          )),

                      const SizedBox(height: 24),

                      /// DATE RANGE (Only show for Custom report type)
                      Obx(() {
                        if (controller.selectedReportType.value == 'Custom') {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.dateRange,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDatePickerField(
                                      label: AppStrings.startDate,
                                      controller:
                                          controller.startDateController,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomDatePickerField(
                                      label: AppStrings.endDate,
                                      controller:
                                          controller.endDateController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        } else {
                          // For Monthly and Weekly, show the date range as read-only info
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppStrings.dateRangeLabel} (${controller.selectedReportType.value})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardBackgroundDark
                                      : AppColors.cardBackgroundLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'From: ${controller.startDateController.text}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'To: ${controller.endDateController.text}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        }
                      }),

                      const SizedBox(height: 24),

                      /// FILTERS
                      Text(
                        AppStrings.filtersOptional,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// PART FILTER
                      Obx(() => CustomDropdown(
                            label: AppStrings.partName,
                            value:
                                controller.selectedPartName.value,
                            items: controller.partNames,
                            onChanged:
                                controller.updateSelectedPartName,
                          )),

                      const SizedBox(height: 16),

                      /// USER FILTER (ADMIN ONLY)
                      Obx(() {
                        if (!userController.isAdmin) {
                          return const SizedBox();
                        }

                        final userOptions = [AppStrings.allUsers, ...controller.users.map((u) => u.nom)];

                        return DropdownButtonFormField<String>(
                          value: controller.selectedUserId.value.isEmpty
                              ? AppStrings.allUsers
                              : controller.users.firstWhereOrNull((u) => u.id == controller.selectedUserId.value)?.nom ?? AppStrings.allUsers,
                          isExpanded: true,
                          decoration: _inputDecoration(isDark),
                          dropdownColor: isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.cardBackgroundLight,
                          items: userOptions.map((userName) => DropdownMenuItem(
                            value: userName,
                            child: Text(userName),
                          )).toList(),
                          onChanged: (value) {
                            if (value == AppStrings.allUsers) {
                              controller.updateSelectedUserId('');
                            } else {
                              final selectedUser = controller.users.firstWhereOrNull((u) => u.nom == value);
                              controller.updateSelectedUserId(selectedUser?.id ?? '');
                            }
                          },
                          hint: Text(
                            AppStrings.selectUser,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            /// BOTTOM BUTTON
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark.withOpacity(0.9)
                    : AppColors.backgroundLight.withOpacity(0.9),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.borderDark.withOpacity(0.3)
                        : AppColors.borderLight.withOpacity(0.3),
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
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark
          ? AppColors.cardBackgroundDark
          : AppColors.cardBackgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}


