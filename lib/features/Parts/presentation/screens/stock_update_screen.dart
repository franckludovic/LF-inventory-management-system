import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/custom_search_field.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/action_toggle.dart';
import '../../../../core/widgets/custom_text_area.dart';

class StockUpdateScreen extends StatefulWidget {
  const StockUpdateScreen({super.key});

  @override
  State<StockUpdateScreen> createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends State<StockUpdateScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedBag;
  int _quantity = 1;
  bool _isAddStock = true;
  bool _showAddLocation = false;
  String? _selectedAdditionalLocation;

  final List<String> _bagOptions = [
    'Sac 1 - Main Inventory',
    'Sac 2 - Service Van',
    'Sac 3 - Emergency Kit',
  ];

  final List<String> _availableLocations = [
    'Sac 3',
    'Sac 6',
    'Sac 1',
    'Bin 12A',
    'Service Truck A',
    'Sac 9',
    'HQ Depot',
    'External Warehouse',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Top AppBar
          Container(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark.withOpacity(0.95) : AppColors.cardBackgroundLight.withOpacity(0.95),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                Expanded(
                  child: Text(
                    'Update Stock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Main Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Part TextField
                  CustomSearchField(
                    label: 'SELECT PART',
                    hint: 'Search elevator part...',
                    currentStock: 'Current Stock: 14 units',
                    controller: _searchController,
                  ),
                  const SizedBox(height: 24),

                  // Select Bag Dropdown
                  CustomDropdown(
                    label: 'STORAGE BAG',
                    value: _selectedBag,
                    items: _bagOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedBag = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Add Location Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showAddLocation = !_showAddLocation;
                        });
                      },
                      icon: Icon(
                        _showAddLocation ? Icons.remove : Icons.add,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'Add Location',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Additional Location Dropdown (shown when Add Location is clicked)
                  if (_showAddLocation) ...[
                    const SizedBox(height: 16),
                    CustomDropdown(
                      label: 'ADDITIONAL LOCATION',
                      value: _selectedAdditionalLocation,
                      items: _availableLocations,
                      onChanged: (value) {
                        setState(() {
                          _selectedAdditionalLocation = value;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Quantity Field
                  QuantitySelector(
                    label: 'QUANTITY',
                    quantity: _quantity,
                    onIncrement: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                    onDecrement: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Toggle (Add / Remove)
                  ActionToggle(
                    isAddStock: _isAddStock,
                    onToggle: (isAdd) {
                      setState(() {
                        _isAddStock = isAdd;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Optional Note
                  CustomTextArea(
                    label: 'OPTIONAL NOTE',
                    hint: 'E.g. Damaged unit return, site transfer...',
                    controller: _noteController,
                  ),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),

          // Footer Button
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
            child: ElevatedButton(
              onPressed: () {
                // Navigate to success screen
                Get.toNamed('/stock-update-success');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Confirm Change',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
