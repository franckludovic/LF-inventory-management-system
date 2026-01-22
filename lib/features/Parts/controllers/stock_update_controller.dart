import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

class StockUpdateController extends GetxController {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Part selection
  PartModel? selectedPart;
  final RxBool isLoading = false.obs;

  final PartsService _partsService = PartsService();

  final RxString selectedBag = RxString('');
  final RxInt quantity = 1.obs;
  final RxBool isAddStock = true.obs;
  final RxBool showAddLocation = false.obs;
  final RxString selectedAdditionalLocation = RxString('');


  final List<String> bagOptions = [
    'Sac 1 - Main Inventory',
    'Sac 2 - Service Van',
    'Sac 3 - Emergency Kit',
  ];

  final List<String> availableLocations = [
    'Sac 3',
    'Sac 6',
    'Sac 1',
    'Bin 12A',
    'Service Truck A',
    'Sac 9',
    'HQ Depot',
    'External Warehouse',
  ];


  void selectBag(String? value) {
    selectedBag.value = value ?? '';
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleAction(bool isAdd) {
    isAddStock.value = isAdd;
  }

  void toggleAddLocation() {
    showAddLocation.value = !showAddLocation.value;
  }

  void selectAdditionalLocation(String? value) {
    selectedAdditionalLocation.value = value ?? '';
  }

  void selectPart(PartModel part) {
    selectedPart = part;
    selectedBag.value = part.location;
  }

  Future<void> confirmChange() async {
    if (selectedPart == null) {
      Get.snackbar('Error', 'Please select a part first');
      return;
    }

    if (quantity.value <= 0) {
      Get.snackbar('Error', 'Quantity must be greater than 0');
      return;
    }

    isLoading.value = true;

    try {
      final operation = isAddStock.value ? 'add' : 'remove';
      final userController = Get.find<UserController>();
      final result = await _partsService.updateStock(
        userController.accessToken.value,
        partId: selectedPart!.id ?? '',
        quantity: quantity.value,
        operation: operation,
        note: noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
      );

      Get.snackbar('Success', 'Stock updated successfully');
      Get.toNamed('/stock-update-success');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update stock: $e');
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    searchController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
