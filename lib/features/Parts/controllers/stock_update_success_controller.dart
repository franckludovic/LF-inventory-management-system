import 'package:get/get.dart';

class StockUpdateSuccessController extends GetxController {

  final RxString successMessage = 'Stock updated successfully!'.obs;
  final RxString updatedPartName = ''.obs;
  final RxInt updatedQuantity = 0.obs;


  void goToDashboard() {
    Get.offAllNamed('/dashboard');
  }

  void goToPartsList() {
    Get.offNamed('/search');
  }

  void updateSuccessDetails(String partName, int quantity) {
    updatedPartName.value = partName;
    updatedQuantity.value = quantity;
  }


  String get formattedSuccessMessage {
    if (updatedPartName.isNotEmpty) {
      return 'Successfully updated $updatedPartName quantity to $updatedQuantity';
    }
    return successMessage.value;
  }
}
