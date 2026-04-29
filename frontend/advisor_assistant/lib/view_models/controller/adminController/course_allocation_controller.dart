import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AllocationController extends GetxController {
  var allocationList = [].obs;
  var isLoading = false.obs;
  var fileName = "No file selected".obs;
  File? selectedFile;

  final String apiUrl = "http://127.0.0.1:5000/api/course-allocations";

  @override
  void onInit() {
    super.onInit();
    fetchAllocations();
  }

  // 1. Fetch All Allocations
  Future<void> fetchAllocations() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        allocationList.assignAll(json.decode(res.body));
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  // 2. Pick Excel File
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

  // 3. Upload Excel to DB
  Future<void> uploadToDB() async {
    if (selectedFile == null) return;

    isLoading.value = true;
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$apiUrl/upload-excel"));
      request.files.add(await http.MultipartFile.fromPath('file', selectedFile!.path));

      var response = await request.send();
      if (response.statusCode == 201) {
        fileName.value = "No file selected";
        selectedFile = null;
        await fetchAllocations(); // List refresh karein

        // YAHAN DIALOG SHOW HOGA
        _showSuccessDialog("Course Allocations synced successfully!");
      } else {
        Get.snackbar("Error", "Server returned: ${response.statusCode}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // 4. Update Allocation
  Future<void> updateAllocation(String id, Map<String, dynamic> updatedData) async {
    try {
      final res = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (res.statusCode == 200) {
        fetchAllocations();
        Get.back(); // Dialog band karein
        Get.snackbar("Updated", "Record updated successfully", backgroundColor: Colors.blue, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  // 5. Delete Allocation
  Future<void> deleteAllocation(String id) async {
    try {
      final res = await http.delete(Uri.parse("$apiUrl/$id"));
      if (res.statusCode == 200) {
        fetchAllocations();
        Get.snackbar("Deleted", "Record removed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
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
              // Lottie Animation (Wahi link jo baqi screens par hai)
              Lottie.asset(
                  'assets/lottie/Sucess.json',
                  height: 150,
                  repeat: false
              ),
              const Text(
                  "Success!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)
              ),
              const SizedBox(height: 10),
              Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
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