import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/features/reports/controllers/report_details_controller.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/report_summary_card.dart';
import '../../../../core/widgets/activity_list_item.dart';
import '../../../../core/controllers/user_controller.dart';

class ReportDetailsScreen extends GetView<ReportDetailsController> {
  const ReportDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark.withOpacity(0.95) : AppColors.cardBackgroundLight.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                      child: Text(
                            AppStrings.stockActivityReport,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Stats Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Report Period
                          Obx(() => ReportSummaryCard(
                            label: AppStrings.reportPeriod,
                            value: controller.reportPeriod.value,
                            icon: Icons.calendar_today,
                            iconColor: AppColors.primary,
                          )),
                          const SizedBox(height: 16),
                          // Total Additions, Removals, and Records
                          Row(
                            children: [
                              Expanded(
                                child: Obx(() => ReportSummaryCard(
                                  label: AppStrings.totalAdditions,
                                  value: '+${controller.totalAdditions.value}',
                                  iconColor: Colors.green[600],
                                )),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Obx(() => ReportSummaryCard(
                                  label: AppStrings.totalRemovals,
                                  value: '-${controller.totalRemovals.value}',
                                  iconColor: Colors.red[600],
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(() => ReportSummaryCard(
                            label: AppStrings.totalRecords,
                            value: '${controller.totalRecords.value}',
                            icon: Icons.list_alt,
                            iconColor: AppColors.primary,
                          )),
                        ],
                      ),
                    ),

                    // Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.activityDetails,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            AppStrings.detailedBreakdown,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Activity Table/List
                    Container(
                      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    AppStrings.date,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    AppStrings.part,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    AppStrings.type,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    AppStrings.qtyShort,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (userController.isAdmin)
                                  SizedBox(
                                    width: 30,
                                    child: Text(
                                      AppStrings.by,
                                      style: TextStyle(
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Activity Items
                          Obx(() => Column(
                            children: controller.activities.map((activity) {
                              return ActivityListItem(
                                date: activity['date'],
                                partName: activity['part'],
                                location: activity['location'],
                                type: activity['type'],
                                quantity: activity['qty'].toString(),
                                by: activity['by'],
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                    ),
                    // Space for bottom buttons
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Footer Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.exportPDF,
                          icon: const Icon(Icons.picture_as_pdf, size: 20),
                          label: Text(AppStrings.exportPDF),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                            foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.exportCSV,
                          icon: const Icon(Icons.table_chart, size: 20),
                          label: Text(AppStrings.exportCSV),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                            foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
