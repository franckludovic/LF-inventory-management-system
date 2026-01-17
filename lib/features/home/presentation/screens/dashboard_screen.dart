import 'package:flutter/material.dart';
import 'package:lf_project/core/widgets/custom_app_bar.dart';
import 'package:lf_project/core/widgets/search_bar.dart';
import 'package:lf_project/core/widgets/action_button.dart';
import 'package:lf_project/core/widgets/stock_alert_card.dart';
import 'package:lf_project/core/widgets/custom_bottom_nav.dart';
import 'package:lf_project/core/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;


  void _onSearchChanged(String value) {
    // TODO: Implement search functionality
    print('Search: $value');
  }

  void _onActionButtonPressed(String action) {
    // TODO: Navigate to respective screens
    print('Action: $action');
  }

  void _onRestockPressed(String item) {
    // TODO: Implement restock functionality
    print('Restock: $item');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Spare Parts Inventory',
        onProfileTap: () {
          // TODO: Navigate to profile
          print('Profile tapped');
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  CustomSearchBar(
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  ActionButton(
                    icon: Icons.manage_search,
                    title: 'Search Parts',
                    subtitle: 'Browse full catalog',
                    onPressed: () => _onActionButtonPressed('search'),
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    icon: Icons.sync_alt,
                    title: 'Add / Remove Stock',
                    subtitle: 'Update current levels',
                    onPressed: () => _onActionButtonPressed('stock'),
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    icon: Icons.photo_camera,
                    title: 'Capture Image',
                    subtitle: 'Scan barcode or visual ID',
                    onPressed: () => _onActionButtonPressed('capture'),
                  ),
                  const SizedBox(height: 32),

                  // Low Stock Alert Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Low Stock Alert',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to full alerts view
                          print('View All tapped');
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock Alert Cards
                  StockAlertCard(
                    title: 'Traction Cable - 12mm',
                    subtitle: 'Only 2 units remaining',
                    status: 'CRITICAL STOCK',
                    statusColor: AppColors.error,
                    statusIcon: Icons.warning,
                    onRestockPressed: () => _onRestockPressed('Traction Cable - 12mm'),
                  ),
                  const SizedBox(height: 16),
                  StockAlertCard(
                    title: 'Door Interlock Switch',
                    subtitle: 'Only 5 units remaining',
                    status: 'LOW STOCK',
                    statusColor: AppColors.warning,
                    statusIcon: Icons.inventory_2,
                    onRestockPressed: () => _onRestockPressed('Door Interlock Switch'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
