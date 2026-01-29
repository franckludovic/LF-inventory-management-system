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
                              AppStrings.weeklyStockActivityReport,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          )),

                      const SizedBox(height: 24),

                      /// DATE RANGE
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

                      /// TECHNICIAN FILTER (ADMIN ONLY)
                      Obx(() {
                        if (!userController.isAdmin) {
                          return const SizedBox();
                        }

                        final selectedTechnician = controller
                            .technicians
                            .firstWhereOrNull(
                              (t) =>
                                  t.id ==
                                  controller
                                      .selectedTechnicianId.value,
                            );

                        return TextFormField(
                          readOnly: true,
                          initialValue:
                              selectedTechnician?.nom ??
                                  'Select Technician',
                          decoration: _inputDecoration(isDark)
                              .copyWith(
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          onTap: () async {
                            if (controller.technicians.isEmpty) {
                              await controller.loadTechnicians();
                            }

                            showModalBottomSheet(
                              context: context,
                              builder: (_) => _TechnicianPicker(
                                isDark: isDark,
                                controller: controller,
                              ),
                            );
                          },
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

class _TechnicianPicker extends StatelessWidget {
  final bool isDark;
  final GenerateReportController controller;

  const _TechnicianPicker({
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            AppStrings.selectTechnician,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: controller.technicians.isEmpty
                ? const Center(child: Text('No technicians'))
                : ListView.builder(
                    itemCount: controller.technicians.length,
                    itemBuilder: (_, index) {
                      final tech =
                          controller.technicians[index];
                      return ListTile(
                        title: Text(tech.nom),
                        onTap: () {
                          controller.updateSelectedTechnicianId(
                              tech.id);
                          Get.back();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}