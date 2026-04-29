import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_models/controller/adminController/course_allocation_controller.dart';

class AllocationView extends StatelessWidget {
  const AllocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllocationController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchAllocations(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // --- Import Card ---
                _buildUploadCard(controller),

                const SizedBox(height: 35),

                // --- Table Header ---
                _buildTableHeader(controller),
                const SizedBox(height: 15),

                // --- Table Data ---
                _buildAllocationTable(controller, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard(AllocationController controller) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: const Color(0xFFFF6D00).withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const Text("Course Allocation", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
          const SizedBox(height: 8),
          const Text("Upload subject assignment via .xlsx file", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => controller.pickExcelFile(),
            child: _buildFilePickerBox(controller),
          ),
          const SizedBox(height: 25),
          _buildUploadButton(controller),
        ],
      ),
    );
  }

  Widget _buildFilePickerBox(AllocationController controller) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(Icons.assignment_ind_rounded, color: Color(0xFFFF9100)),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => Text(controller.fileName.value, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepOrange), overflow: TextOverflow.ellipsis)),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: const Color(0xFFFF9100), borderRadius: BorderRadius.circular(15)),
            alignment: Alignment.center,
            child: const Text("Browse", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(AllocationController controller) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.uploadToDB(),
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
                : const Text("Upload Allocation", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      )),
    );
  }

  Widget _buildTableHeader(AllocationController controller) {
    return Row(
      children: [
        const Icon(Icons.view_list_rounded, color: Color(0xFFFF6D00)),
        const SizedBox(width: 10),
        const Text("Allocations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
          child: Text("${controller.allocationList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  Widget _buildAllocationTable(AllocationController controller, BuildContext context) {
    return Obx(() {
      if (controller.allocationList.isEmpty) return const Center(child: Text("No records found."));
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
              columnSpacing: 25,
              headingRowHeight: 55,
              headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),
              columns: const [
                DataColumn(label: Text('Batch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Sec', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Subject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Teacher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
              rows: controller.allocationList.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['batch'] ?? "")),
                    DataCell(Text(item['session'] ?? "")),
                    DataCell(Text(item['section'] ?? "")),
                    DataCell(Text(item['subject'] ?? "")),
                    DataCell(Text(item['teacher_name'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange))),
                    DataCell(Row(
                      children: [
                        IconButton(icon: const Icon(Icons.edit_note, color: Colors.blue), onPressed: () => _showEditDialog(context, item, controller)),
                        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => controller.deleteAllocation(item['_id'])),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  // Edit Dialogue Logic
  void _showEditDialog(BuildContext context, dynamic item, AllocationController controller) {
    final subCtrl = TextEditingController(text: item['subject']);
    final teacherCtrl = TextEditingController(text: item['teacher_name']);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Allocation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
              const SizedBox(height: 20),
              _buildEditField(subCtrl, "Subject", Icons.book_outlined),
              const SizedBox(height: 15),
              _buildEditField(teacherCtrl, "Teacher Name", Icons.person_pin_outlined),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6D00), minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  // Controller update logic call
                  Get.back();
                },
                child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF8E1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}