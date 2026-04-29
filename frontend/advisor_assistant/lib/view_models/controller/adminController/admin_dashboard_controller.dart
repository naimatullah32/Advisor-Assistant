import 'package:get/get.dart';

class AdminDashboardController extends GetxController {

  var currentView = "Home".obs;

  void changeView(String view) {
    currentView.value = view;
  }
}
