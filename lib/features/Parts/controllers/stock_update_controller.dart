import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../core/constants/strings.dart';

class StockUpdateController extends GetxController {
  final PartModel? initialPart;

  StockUpdateController({this.initialPart});

  final TextEditingController noteController = TextEditingController();

  // Part selection
  final Rx<PartModel?> selectedPart = Rx<PartModel?>(null);
  final RxBool isLoading = false.obs;

  final PartsService _partsService = PartsService();

  final RxString selectedLocation = RxString('');
  final RxInt quantity = 1.obs;
  final RxBool isAddStock = true.obs;

  final RxList<Map<String, String>> partLocations = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Check if a part was passed as argument or initial part
    final part = initialPart ?? Get.arguments as PartModel?;
    if (part != null) {
      selectPart(part);
    }
  }

  void selectLocation(String location) {
    selectedLocation.value = location;
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

  void selectPart(PartModel part) {
    selectedPart.value = part;
    partLocations.assignAll(part.locations ?? []);
  }

  Future<void> confirmChange() async {
    if (selectedPart.value == null) {
      Get.snackbar('Error', 'Please select a part first');
      return;
    }

    if (selectedLocation.value.isEmpty) {
      Get.snackbar('Error', 'Please select a location');
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
        partId: selectedPart.value!.id ?? '',
        sacName: selectedLocation.value,
        quantity: quantity.value,
        operation: operation,
        note: noteController.text.trim().isNotEmpty
            ? noteController.text.trim()
            : null,
      );

      Get.snackbar('Success', 'Stock updated successfully');
      // Stay on the page instead of navigating away
    } catch (e) {
      final errorMessage = e.toString();
      Get.snackbar('Error', 'Failed to update stock: $errorMessage');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
