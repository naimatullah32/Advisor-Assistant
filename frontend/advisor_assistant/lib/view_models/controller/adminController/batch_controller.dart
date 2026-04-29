import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class BatchController extends GetxController {
  var batchList = [].obs;
  var isLoading = false.obs;
  final batchNameController = TextEditingController();

  final String apiUrl = "http://127.0.0.1:5000/api/batches"; // Replace with your IP

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        batchList.value = json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  Future<void> addBatch() async {
    if (batchNameController.text.isEmpty) {
      Get.snackbar("Error", "Please enter batch name",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "batch_id": batchNameController.text,
          "start_year": int.tryParse(batchNameController.text.split('-')[0]) ?? 2024,
          "end_year": int.tryParse(batchNameController.text.split('-').last) ?? 2028,
        }),
      );

      if (response.statusCode == 201) {
        batchNameController.clear();
        await fetchBatches();
        _showSuccessDialog(); // Lottie Dialog Call
      }
    } catch (e) {
      Get.snackbar("Error", "Server connection failed");
    } finally {
      isLoading.value = false;
    }
  }

  // Batch Update function
  Future<void> updateBatch(String id, String newBatchId) async {
    if (newBatchId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "batch_id": newBatchId,
          "start_year": int.tryParse(newBatchId.split('-')[0]) ?? 2024,
          "end_year": int.tryParse(newBatchId.split('-').last) ?? 2028,
        }),
      );

      if (response.statusCode == 200) {
        fetchBatches(); // List refresh karein
        Get.back(); // Dialog band karein
        Get.snackbar("Updated", "Batch updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBatch(String id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        fetchBatches();
        Get.snackbar("Deleted", "Batch removed", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Lottie Success Dialog
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
                width: 200,
                repeat: false,
              ),
              const SizedBox(height: 10),
              const Text("Batch Added!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const Text("The new batch has been saved.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () => Get.back(),
                child: const Text("Perfect", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}