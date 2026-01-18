import 'package:get/get.dart';
import '../../../core/models/part_model.dart';

class PartDetailsController extends GetxController {
  final PartModel part;

  PartDetailsController(this.part);


  final RxBool isLoading = false.obs;

  void sharePart() {
    // TODO: Implement share functionality
    // This could open a share dialog or copy part details to clipboard
    Get.snackbar(
      'Share',
      'Share functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goBack() {
    Get.back();
  }

  String get formattedReferenceNumber {
    return part.referenceNumber ?? 'REF-${part.name.replaceAll(' ', '-').toUpperCase()}';
  }

  String get quantityValue {
    return part.quantity.replaceAll('Qty: ', '');
  }

  bool get hasLocations {
    return part.locations != null && part.locations!.isNotEmpty;
  }
}
