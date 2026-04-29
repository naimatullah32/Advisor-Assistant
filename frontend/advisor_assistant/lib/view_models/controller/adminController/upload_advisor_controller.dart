import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AdvisorController extends GetxController {
  var fileName = "advisor_list.xlsx".obs;
  var advisorsList = [].obs;
  var isLoading = false.obs;
  File? pickedFile;

  final String apiUrl = "http://127.0.0.1:5000/api/advisors"; // Apni IP se badlein

  @override
  void onInit() {
    super.onInit();
    fetchAdvisors();
  }

  Future<void> fetchAdvisors() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/all'));
      if (response.statusCode == 200) {
        advisorsList.value = json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      pickedFile = File(result.files.first.path!);
      fileName.value = result.files.first.name;
    }
  }

  Future<void> uploadToDB() async {
    if (pickedFile == null) {
      Get.snackbar("Notice", "Please select a file first",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload-excel'));
      request.files.add(await http.MultipartFile.fromPath('file', pickedFile!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await fetchAdvisors();
        _showSuccessDialog();
      } else {
        Get.snackbar("Error", "Upload failed", backgroundColor: Colors.redAccent);
      }
    } catch (e) {
      Get.snackbar("Error", "Check backend connection");
    } finally {
      isLoading.value = false;
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
              Lottie.asset(
                'assets/lottie/Sucess.json',
                width: 150,
                repeat: false,
              ),
              const SizedBox(height: 10),
              const Text("Uploaded!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const Text("Advisor database synchronized.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => Get.back(),
                child: const Text("Great!", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}