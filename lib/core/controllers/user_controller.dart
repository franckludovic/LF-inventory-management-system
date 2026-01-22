import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<String> userRole = <String>[].obs;
  final RxString username = ''.obs;
  final RxString accessToken = ''.obs;
  final RxString refreshToken = ''.obs;
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  void setUser(String username, List<String> roles) {
    this.username.value = username;
    this.userRole.value = roles;
  }

  void setTokens(String accessToken, String refreshToken) {
    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;
  }

  void setUserProfile(Map<String, dynamic> profile) {
    userProfile.value = profile;
    user.value = UserModel.fromMap(profile);
    // Update username and role from profile if available
    if (profile.containsKey('nom')) {
      username.value = profile['nom'];
    }
    if (profile.containsKey('role')) {
      userRole.assignAll(List<String>.from(profile['role']));
    }
  }

  bool get isAdmin => userRole.contains('ROLE_ADMIN');
  bool get isTechnician => userRole.contains('ROLE_TECHNICIAN');

  bool get isLoggedIn => accessToken.isNotEmpty;

  void logout() {
    username.value = '';
    userRole.clear();
    accessToken.value = '';
    refreshToken.value = '';
    userProfile.clear();
    user.value = null;
  }
}
