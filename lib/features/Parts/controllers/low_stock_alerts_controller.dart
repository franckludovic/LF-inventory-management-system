import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

class LowStockAlertsController extends GetxController {
  var isLoading = false.obs;
  var allLowStockParts = <PartModel>[].obs;
  
  // Search
  var searchQuery = ''.obs;
  
  // Filter by quantity - new criteria: 5 or less is low stock
  var selectedQuantityFilter = Rx<String?>('Tous (5 ou moins)');
  final quantityFilters = [
    'Tous (5 ou moins)',
    '4 ou moins',
    '3 ou moins', 
    '2 ou moins',
    '1 ou moins',
    'Rupture (0)'
  ];
  
  // Sort
  var selectedSort = Rx<String?>('Nom A-Z');
  final sortOptions = ['Nom A-Z', 'Nom Z-A', 'Quantité Croissante', 'Quantité Décroissante'];

  final PartsService _partsService = PartsService();

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;
      final userController = Get.find<UserController>();
      final partsData = await _partsService.getAllParts(userController.accessToken.value);
      final parts = partsData.map((part) => PartModel.fromMap(part)).toList();

      // Get all low stock parts (quantity <= 5 is low stock)
      allLowStockParts.assignAll(
        parts.where((part) {
          final qty = int.tryParse(part.quantity) ?? 0;
          return qty <= 5; // Low stock: 5 or less
        }).toList()
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du chargement des alertes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get filtered and sorted parts
  List<PartModel> get filteredAndSortedParts {
    var parts = List<PartModel>.from(allLowStockParts);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      parts = parts.where((part) {
        final designation = part.designation?.toLowerCase() ?? '';
        final reference = part.reference?.toLowerCase() ?? '';
        return designation.contains(searchQuery.value.toLowerCase()) ||
               reference.contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Apply quantity filter
    if (selectedQuantityFilter.value != null && selectedQuantityFilter.value != 'Tous (5 ou moins)') {
      switch (selectedQuantityFilter.value) {
        case '4 ou moins':
          parts = parts.where((part) => (int.tryParse(part.quantity) ?? 0) <= 4).toList();
          break;
        case '3 ou moins':
          parts = parts.where((part) => (int.tryParse(part.quantity) ?? 0) <= 3).toList();
          break;
        case '2 ou moins':
          parts = parts.where((part) => (int.tryParse(part.quantity) ?? 0) <= 2).toList();
          break;
        case '1 ou moins':
          parts = parts.where((part) => (int.tryParse(part.quantity) ?? 0) <= 1).toList();
          break;
        case 'Rupture (0)':
          parts = parts.where((part) => (int.tryParse(part.quantity) ?? 0) == 0).toList();
          break;
      }
    }

    // Apply sort
    switch (selectedSort.value) {
      case 'Nom A-Z':
        parts.sort((a, b) => a.designation.compareTo(b.designation));
        break;
      case 'Nom Z-A':
        parts.sort((a, b) => b.designation.compareTo(a.designation));
        break;
      case 'Quantité Croissante':
        parts.sort((a, b) => (int.tryParse(a.quantity) ?? 0).compareTo(int.tryParse(b.quantity) ?? 0));
        break;
      case 'Quantité Décroissante':
        parts.sort((a, b) => (int.tryParse(b.quantity) ?? 0).compareTo(int.tryParse(a.quantity) ?? 0));
        break;
    }

    return parts;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onQuantityFilterChanged(String? value) {
    selectedQuantityFilter.value = value;
  }

  void onSortChanged(String? value) {
    selectedSort.value = value;
  }

  void navigateToPartDetails(PartModel part) {
    Get.toNamed('/part-details', arguments: part);
  }
}
