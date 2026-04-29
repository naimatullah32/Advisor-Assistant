import 'package:get/get.dart';

class AdvisorHomeController extends GetxController {

  /// Selected Filters
  RxString selectedBatch = '2022-2026'.obs;
  RxString selectedProgram = 'BSCS'.obs;
  RxString selectedSection = 'A'.obs;

  /// Current View
  RxString currentView = 'Home'.obs;

  /// Students List
  final students = [
    {'reg': '222-NUN-0040', 'name': 'M.Aftab', 'father': 'Ali', 'contact': '03017 2793283'},
    {'reg': '222-NUN-0042', 'name': 'Nemat Ullah', 'father': 'Nasher Khan', 'contact': '03017 2793283'},
    {'reg': '222-NUN-0033', 'name': 'Hamz Ullah', 'father': 'Habib Khan', 'contact': '03017 2793283'},
  ].obs;

  void changeView(String view) {
    currentView.value = view;
  }

  void changeBatch(String value) {
    selectedBatch.value = value;
  }

  void changeProgram(String value) {
    selectedProgram.value = value;
  }

  void changeSection(String value) {
    selectedSection.value = value;
  }
}
