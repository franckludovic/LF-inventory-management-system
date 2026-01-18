import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockUpdateController extends GetxController {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();


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

  void confirmChange() {
    // TODO: Implement stock update logic
    Get.toNamed('/stock-update-success');
  }


  @override
  void onClose() {
    searchController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
