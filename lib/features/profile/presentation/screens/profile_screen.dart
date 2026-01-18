import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/profile_list_item.dart';
import '../../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.profile,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                        child: Icon(
                          Icons.person,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ), Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Name and details
                  Obx(() => Text(
                    controller.userName.value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.userRole.value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    'Employee ID: ${controller.employeeId.value}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  )),
                ],
              ),
            ),
            // General Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Information',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      letterSpacing: 1.5,
                    ).copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Obx(() => ProfileListItem(
                          icon: Icons.mail,
                          title: controller.email.value,
                          subtitle: 'Email Address',
                        )),
                        Obx(() => ProfileListItem(
                          icon: Icons.business,
                          title: controller.department.value,
                          subtitle: 'Department',
                        )),
                        Obx(() => ProfileListItem(
                          icon: Icons.location_on,
                          title: controller.region.value,
                          subtitle: 'Region',
                        )),
                        Obx(() => ProfileListItem(
                          icon: Icons.calendar_today,
                          title: controller.joinedDate.value,
                          subtitle: 'Joined Date',
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Account Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      letterSpacing: 1.5,
                    ).copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileListItem(
                          icon: Icons.settings,
                          title: 'Preferences',
                          subtitle: '',
                          showChevron: true,
                          onTap: controller.navigateToPreferences,
                        ),
                        ProfileListItem(
                          icon: Icons.security,
                          title: 'Security & Password',
                          subtitle: '',
                          showChevron: true,
                          onTap: controller.navigateToSecurity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Log Out'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Version info
            Text(
              'Version 2.4.1 (Build 882)',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
