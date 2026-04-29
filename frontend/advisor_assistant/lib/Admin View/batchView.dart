import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../view_models/controller/adminController/batch_controller.dart';

class BatchView extends StatelessWidget {
  const BatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BatchController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchBatches(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Lottie.network(
                  'https://lottie.host/81775a7c-572e-4074-903b-9e4a36277271/H8R3v9gQ62.json',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.groups, size: 80, color: Colors.orange),
                ),
                const SizedBox(height: 20),

                // --- Main Entry Card ---
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFF6D00).withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("Batch Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
                      const SizedBox(height: 8),
                      const Text("Add or update university batches", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),

                      // Manual Input Field
                      TextField(
                        controller: controller.batchNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Batch (e.g. 2022-2026)",
                          prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFFFF9100)),
                          filled: true,
                          fillColor: const Color(0xFFFFF8E1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Color(0xFFFFB74D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Color(0xFFFF9100), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.addBatch(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFF9100), Color(0xFFFF6D00)]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Save Batch", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // --- Records Header ---
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 10),
                    const Text("Batch Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
                      child: Text("${controller.batchList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                    )),
                  ],
                ),
                const SizedBox(height: 15),

                // --- Interactive Table ---
                Obx(() {
                  if (controller.batchList.isEmpty) {
                    return const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: Text("No records found", style: TextStyle(color: Colors.grey))));
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 60,
                          headingRowHeight: 55,
                          headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),
                          columns: const [
                            DataColumn(label: Text('Batch Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Start Year', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('End Year', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                          rows: controller.batchList.map((batch) {
                            return DataRow(
                              cells: [
                                DataCell(Text(batch['batch_id']?.toString() ?? "", style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(batch['start_year']?.toString() ?? "-")),
                                DataCell(Text(batch['end_year']?.toString() ?? "-")),
                                DataCell(Row(
                                  children: [
                                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue),onPressed: () {
                                      // Edit Dialog kholne ke liye
                                      _showEditDialog(batch['_id'], batch['batch_id']);
                                    },),
                                    IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => controller.deleteBatch(batch['_id'])
                                    ),
                                  ],
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String id, String currentName) {
    final editController = TextEditingController(text: currentName);
    final controller = Get.find<BatchController>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Update Batch"),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: "Enter new batch name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => controller.updateBatch(id, editController.text),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}