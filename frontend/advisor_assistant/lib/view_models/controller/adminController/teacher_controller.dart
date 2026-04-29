import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class TeacherController extends GetxController {
  var teachersList = [].obs;
  var isLoading = false.obs;
  var fileName = "No file selected".obs;
  File? selectedFile;

  final String apiUrl = "http://127.0.0.1:5000/api/teachers";

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  // File Picker Logic
  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      fileName.value = result.files.single.name;
    }
  }

  // Excel Upload to MongoDB
  Future<void> uploadToDB() async {
    if (selectedFile == null) {
      Get.snackbar("Error", "Pehle Excel file select karein",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    print("Starting Upload... File Path: ${selectedFile!.path}");

    try {
      // 1. Multipart Request banayein
      var request = http.MultipartRequest('POST', Uri.parse("$apiUrl/upload-excel"));

      // 2. File add karein (Dhyan rakhein 'file' key backend se match kare)
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        selectedFile!.path,
      );
      request.files.add(multipartFile);

      // 3. Request send karein
      var streamedResponse = await request.send();

      // 4. Response read karein
      var response = await http.Response.fromStream(streamedResponse);
      print("Server Response Status: ${response.statusCode}");
      print("Server Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        fileName.value = "No file selected";
        selectedFile = null;
        await fetchTeachers(); // Table refresh
        _showSuccessDialog("Teachers list uploaded successfully!");
      } else {
        // Agar backend se koi masla hai (e.g. 500 ya 400 error)
        Get.snackbar("Upload Failed", "Server Error: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Exception during upload: $e");
      Get.snackbar("Error", "Connection ka masla hai ya server band hai",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTeachers() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) teachersList.assignAll(json.decode(res.body));
    } catch (e) { debugPrint(e.toString()); }
  }

  // Teacher Update Function
  Future<void> updateTeacher(String id, String name, String designation, String department) async {
    try {
      isLoading.value = true;
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "designation": designation,
          "department": department,
        }),
      );

      if (response.statusCode == 200) {
        await fetchTeachers(); // Table refresh karein
        Get.back(); // Dialog band karein
        _showSuccessDialog("Teacher details updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to update teacher");
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTeacher(String id) async {
    final res = await http.delete(Uri.parse("$apiUrl/$id"));
    if (res.statusCode == 200) fetchTeachers();
  }

  // Lottie Success Dialog
  void _showSuccessDialog(String msg) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/Sucess.json', height: 150, repeat: false),
              Text("Success!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 10),
              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Get.back(), child: const Text("Done")),
            ],
          ),
        ),
      ),
    );
  }
}