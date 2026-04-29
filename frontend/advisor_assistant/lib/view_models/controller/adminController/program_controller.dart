import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class ProgramController extends GetxController {
  var programList = [].obs;
  var isLoading = false.obs;

  final programNameController = TextEditingController();
  final departmentNameController = TextEditingController();

  final String apiUrl = "http://127.0.0.1:5000/api/programs";

  @override
  void onInit() {
    super.onInit();
    fetchPrograms();
  }

  Future<void> fetchPrograms() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        programList.assignAll(data);
      }
    } catch (e) {
      debugPrint("Error fetching: $e");
    }
  }

  Future<void> addProgram() async {
    if (programNameController.text.trim().isEmpty || departmentNameController.text.trim().isEmpty) {
      Get.snackbar("Required", "All fields are mandatory", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "program_name": programNameController.text.trim(),
          "department_name": departmentNameController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        programNameController.clear();
        departmentNameController.clear();
        await fetchPrograms(); // Sync database
        _showSuccessDialog();
      }
    } catch (e) {
      Get.snackbar("Error", "Check server connection");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProgram(String id, String pName, String dName) async {
    if (pName.isEmpty || dName.isEmpty) return;

    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "program_name": pName.trim(),
          "department_name": dName.trim()
        }),
      );
      if (response.statusCode == 200) {
        await fetchPrograms(); // Table refresh
        Get.back(); // Close dialog
        Get.snackbar("Updated", "Program updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Future<void> deleteProgram(String id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        fetchPrograms();
        Get.snackbar("Deleted", "Program removed", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint(e.toString());
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
              Lottie.network(
                  'assets/lottie/Sucess.json',
                  width: 150, repeat: false
              ),
              const Text("Success!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 10),
              const Text("The program has been added.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => Get.back(),
                  child: const Text("Done", style: TextStyle(color: Colors.white))
              ),
            ],
          ),
        ),
      ),
    );
  }
}