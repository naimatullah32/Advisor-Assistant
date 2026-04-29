import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FeeScheduleController extends GetxController {
  var feeList = [].obs;
  var programList = [].obs;
  var sessionList = [].obs;
  var isLoading = false.obs;

  // Selection variables
  var selectedProgramId = "".obs;
  var selectedSessionId = "".obs;
  var selectedInstallment = "1st Installment".obs;
  var lastDate = "".obs;
  final amountController = TextEditingController();
  var installmentOptions = ["1st Installment", "2nd Installment", "3rd Installment", "4th Installment"].obs;

  final String baseUrl = "http://127.0.0.1:5000/api";

  @override
  void onInit() {
    super.onInit();
    fetchInitialData(); // Dropdowns bharne ke liye
    fetchFeeSchedules(); // Table bharne ke liye
  }

  // Program aur Session tables se data lana dropdown ke liye
  Future<void> fetchInitialData() async {
    try {
      final pRes = await http.get(Uri.parse("$baseUrl/programs"));
      final sRes = await http.get(Uri.parse("$baseUrl/sessions"));

      if (pRes.statusCode == 200) programList.assignAll(json.decode(pRes.body));
      if (sRes.statusCode == 200) {
        var sData = json.decode(sRes.body);
        sessionList.assignAll(sData.reversed.toList()); // Newest session top par
      }
    } catch (e) { debugPrint(e.toString()); }
  }

  // Calendar se date select karna
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      lastDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // Database mein save karna
  Future<void> saveFee() async {
    if (amountController.text.isEmpty || selectedProgramId.isEmpty || lastDate.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/fee-schedules"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amountController.text,
          "installment_no": selectedInstallment.value,
          "last_date": lastDate.value,
          "program": selectedProgramId.value,
          "session": selectedSessionId.value,
        }),
      );
      if (res.statusCode == 201) {
        fetchFeeSchedules();
        amountController.clear();
        Get.snackbar("Success", "Fee Schedule Saved", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally { isLoading.value = false; }
  }

  // Controller mein fetch function ko update karein
  Future<void> fetchFeeSchedules() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/fee-schedules"));
      if (res.statusCode == 200) {
        List rawData = json.decode(res.body);

        // Sorting Logic: 1st, 2nd, 3rd ko sequence mein lane ke liye
        rawData.sort((a, b) {
          return (a['installment_no'] ?? "").toString().compareTo((b['installment_no'] ?? "").toString());
        });

        feeList.assignAll(rawData);
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  Future<void> updateFeeSchedule(String id, String amount, String installment, String date, String pId, String sId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/fee-schedules/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount,
          "installment_no": installment,
          "last_date": date,
          "program": pId,
          "session": sId,
        }),
      );
      if (response.statusCode == 200) {
        fetchFeeSchedules();
        Get.back();
        Get.snackbar("Updated", "Record updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Future<void> deleteFee(String id) async {
    await http.delete(Uri.parse("$baseUrl/fee-schedules/$id"));
    fetchFeeSchedules();
  }

  // Nayi installment add karne ka function
  void addInstallment(String value) {
    if (value.isNotEmpty && !installmentOptions.contains(value)) {
      installmentOptions.add(value);
      installmentOptions.refresh(); // UI ko foran update karne ke liye
    }
  }

// Installment remove karne ka function
  void removeInstallment(String value) {
    installmentOptions.remove(value);
    installmentOptions.refresh(); // Taake dialog band kiye bagair UI update ho jaye
  }
}