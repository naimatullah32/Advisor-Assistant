import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class CourseController extends GetxController {
  var courseList = [].obs;
  var isLoading = false.obs;
  var fileName = "No file selected".obs;
  File? selectedFile;

  final String apiUrl = "http://10.27.134.142:5000/api/courses";

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final res = await http.get(Uri.parse(apiUrl));
    if (res.statusCode == 200) courseList.assignAll(json.decode(res.body));
  }

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

  Future<void> uploadToDB() async {
    if (selectedFile == null) return;
    isLoading.value = true;
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$apiUrl/upload-excel"));
      request.files.add(await http.MultipartFile.fromPath('file', selectedFile!.path));
      var response = await request.send();
      if (response.statusCode == 201) {
        fileName.value = "No file selected";
        fetchCourses();
        _showSuccessDialog("Courses Imported Successfully!");
      }
    } finally { isLoading.value = false; }
  }

  // Update Course
  Future<void> updateCourse(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        await fetchCourses(); // Table refresh
        Get.back(); // Dialog band karein
        _showSuccessDialog("Course updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to update course");
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> deleteCourse(String id) async {
    await http.delete(Uri.parse("$apiUrl/$id"));
    fetchCourses();
  }

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
              const Text("Success!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
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