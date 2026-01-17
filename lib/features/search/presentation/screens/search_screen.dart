import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../data/models/part_model.dart';
import '../widgets/search_part_card.dart';
import 'part_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'In Stock';

  final List<PartModel> _parts = [
    PartModel(
      name: AppStrings.overspeedGovernor,
      brand: AppStrings.otis,
      quantity: 'Qty: 03',
      location: 'Loc: Sac 3, Sac 6',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB5gRhslUJIB3jtZd6jW5B6nl7D5viYuagEGw5x6DD5TDwEEC6vSiDH00pl0K8EmFuv9x2SsmEoTyrrs9QGbIKhysGiPJui5rPEbozYekI1IOwyvjQyaQeY7DMIFImPLve02y1M0X_1JWjk8IR6UsMqnolUPXYm3hJ94SIF80ByyUuqQ6y4GTiKltxrmqA_pEZiMRJwbzNfHuYTT3uKhF580FS62HWFXt2FaW0BSLDIMNXzVFpSeXPGVYWfSVjrtJ587R3XkFy9KU2Z',
      referenceNumber: 'REF-001-OG',
      locations: [
        {'name': 'Sac 3', 'quantity': '02', 'isPrimary': 'true'},
        {'name': 'Sac 6', 'quantity': '01', 'isPrimary': 'false'},
      ],
    ),
    PartModel(
      name: AppStrings.doorRollerAssembly,
      brand: AppStrings.schindler,
      quantity: 'Qty: 12',
      location: 'Loc: Sac 1, Bin 12A',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB2za0GlRhSc3p_lnTuS3NztRjRX-ZMdMlqP3-gloEO_9TzxKXeKh1A3D-cfETyojETLHpyQybbQKBZg3xkBEuaiJTSLQ3q-sKxE4xLbansWM4T1b-FZ_MpMke7-NZXkHTGYmo0mh_C7UAiXJDscklKIHiD-dVpZgf7sISivZNd5EIUpMKxtpliWZMg0yBQ2lYTGr4Yzytj3HbmLsAeiKZFP49ePHENsYtH4WSIuzTlJTc8XFD4VVf32IsMKa5dH2xCcpPWLnR_4hLk',
      referenceNumber: 'REF-002-DRA',
      locations: [
        {'name': 'Sac 1', 'quantity': '10', 'isPrimary': 'true'},
        {'name': 'Bin 12A', 'quantity': '02', 'isPrimary': 'false'},
      ],
    ),
    PartModel(
      name: AppStrings.emergencyLightBattery,
      brand: AppStrings.kone,
      quantity: 'Qty: 01',
      location: 'Loc: Service Truck A',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqw4AEJOfBJvS92xbnKhIXNdK0qk7Y699JBZv1LXLkjrFyoIfwvH_Zfxl49FqIPAZnlG2lWQwGn2NcpcUm-IYsiadksHpzyVNStt25IcjgeRKk-rSdlGfj6qUvB1P8EgBeKkTnfgbovEbL4BifW2Au2SHO-VeZ7bnpOSEHRYRKuurUaIVwsDniPwfthgaL9jddlnshSxChkjp1hAnJIuUhqDLRTwyVqxPXBFi90_xFVCAGZeHGAW61pVNW7JpUMpz2IprzU8kthv5o',
      isLowStock: true,
      referenceNumber: 'REF-003-ELB',
      locations: [
        {'name': 'Service Truck A', 'quantity': '01', 'isPrimary': 'true'},
      ],
    ),
    PartModel(
      name: AppStrings.mainControlPcb,
      brand: AppStrings.genericOem,
      quantity: 'Qty: 02',
      location: 'Loc: Sac 9, HQ Depot',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDk25kJ6yswChqVEWc5QLeu7Igsl4d1wXRlqgEfqq3ugckpa1o-wglzPWV5rEvR-6NwzavOz_EhncEQ-D1iQJJBFdYGmEKDib9tVdIiPy0RrKTlJUEXhvoUhngicDQL8egEu_SCQQAa8T1jODJ2c67k5z1nX-Se-SVlhueViemRjGm9CaVijG-eoVAujr8rjAtdv9mwqTGa8j7rDDHicuDLR5u5bBn5ic3j838PttMN4YkknVbnYhNJUsQtfJuO5NYD-sImcX_1zIYv',
      referenceNumber: 'REF-004-MCP',
      locations: [
        {'name': 'Sac 9', 'quantity': '01', 'isPrimary': 'true'},
        {'name': 'HQ Depot', 'quantity': '01', 'isPrimary': 'false'},
      ],
    ),
    PartModel(
      name: AppStrings.tractionRope12mm,
      brand: AppStrings.thyssenKrupp,
      quantity: 'Qty: 50m',
      location: 'Loc: External Warehouse',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZskCC2F69PUuJzpbvT3C5ZLKwy9VxPs4oKCLd15R9V_Yyso2ReV4Ac-QdjZu8gMB5et0sCzuLEMgxwzH5NN3ZcRUZLjjOrw-A66SEzjTk0NqlZ2qs4YtXONLothwu_sqLnX6O89cFXtrYBgLUp70que-WEdC5QTuhFS9b0i56usAC4oH6toCMuYuAvE9saLP4U929qACMkig5HnmXaDolqLC-YdXoF5M2Ro3DfyJCEZeZJZn-zPHjzwQco92zML94IH618aBNBXAO',
      referenceNumber: 'REF-005-TR12',
      locations: [
        {'name': 'External Warehouse', 'quantity': '50m', 'isPrimary': 'true'},
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark.withOpacity(0.95) : AppColors.backgroundLight.withOpacity(0.95),
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
                    AppStrings.searchSpareParts,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    // TODO: Implement filter functionality
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: AppStrings.searchByPartNameOrSku,
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),

          // Filter Chips
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('In Stock', _selectedFilter == 'In Stock'),
                const SizedBox(width: 12),
                _buildFilterChip('Otis', _selectedFilter == 'Otis'),
                const SizedBox(width: 12),
                _buildFilterChip('Schindler', _selectedFilter == 'Schindler'),
              ],
            ),
          ),

          // Result Count Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark.withOpacity(0.5) : AppColors.cardBackgroundLight.withOpacity(0.5),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              AppStrings.showingResults,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                letterSpacing: 1.2,
              ).copyWith(
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),

          // Parts List
          Expanded(
            child: ListView.builder(
              itemCount: _parts.length,
              itemBuilder: (context, index) {
                final part = _parts[index];
                return SearchPartCard(
                  part: part,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PartDetailsScreen(part: part),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      elevation: isSelected ? 4 : 0,
      shadowColor: AppColors.primary.withOpacity(0.2),
    );
  }


}
