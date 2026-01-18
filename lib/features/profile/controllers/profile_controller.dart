import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable variables for profile data
  var userName = 'John Doe'.obs;
  var userRole = 'Technician'.obs;
  var employeeId = 'TX-9942'.obs;
  var email = 'j.doe@elevator-tech.com'.obs;
  var department = 'Maintenance & Repairs'.obs;
  var region = 'North District'.obs;
  var joinedDate = 'January 12, 2023'.obs;

  // Method to handle logout
  void logout() {
    // Implement logout logic here, e.g., clear session, navigate to login
    Get.offAllNamed('/login'); // Assuming login route exists
  }

  // Method to navigate to preferences
  void navigateToPreferences() {
    // Implement navigation to preferences screen
    // For now, just a placeholder
    Get.snackbar('Preferences', 'Navigate to Preferences Screen');
  }

  // Method to navigate to security settings
  void navigateToSecurity() {
    // Implement navigation to security screen
    // For now, just a placeholder
    Get.snackbar('Security', 'Navigate to Security & Password Screen');
  }
}
