import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Date format ke liye
import 'package:lottie/lottie.dart';

class SessionController extends GetxController {
  var sessionList = [].obs;
  var isLoading = false.obs;

  final sessionNameController = TextEditingController();
  var startDate = "".obs;
  var endDate = "".obs;

  final String apiUrl = "http://127.0.0.1:5000/api/sessions";

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  // Calendar Picker Function
  Future<void> pickDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      if (isStartDate) {
        startDate.value = formattedDate;
      } else {
        endDate.value = formattedDate;
      }
    }
  }

  Future<void> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        sessionList.value = json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> addSession() async {
    if (sessionNameController.text.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      Get.snackbar("Required", "All fields are mandatory", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "session_name": sessionNameController.text.trim(),
          "start_date": startDate.value,
          "end_date": endDate.value,
        }),
      );

      if (response.statusCode == 201) {
        sessionNameController.clear();
        startDate.value = "";
        endDate.value = "";
        fetchSessions();
        _showSuccessDialog();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Edit
  Future<void> updateSession(String id, String name, String sDate, String eDate) async {
    if (name.isEmpty || sDate.isEmpty || eDate.isEmpty) return;

    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "session_name": name.trim(),
          "start_date": sDate,
          "end_date": eDate,
        }),
      );

      if (response.statusCode == 200) {
        await fetchSessions(); // Table refresh karein
        Get.back(); // Dialog band karein
        Get.snackbar("Updated", "Session updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }
  // Delete
  Future<void> deleteSession(String id) async {
    await http.delete(Uri.parse("$apiUrl/$id"));
    fetchSessions();
    Get.snackbar("Deleted", "Session removed successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/Sucess.json', width: 150, repeat: false),
              const Text("Session Saved!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 10),
              const Text("The session has been added.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Get.back(), child: const Text("Done")),
            ],
          ),
        ),
      ),
    );
  }
