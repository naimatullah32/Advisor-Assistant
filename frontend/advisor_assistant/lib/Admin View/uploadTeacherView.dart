import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/controller/adminController/teacher_controller.dart';

class UploadTeacherView extends StatelessWidget {
  const UploadTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchTeachers(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // --- Import Card ---
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [BoxShadow(color: const Color(0xFFFF6D00).withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      const Text("Import Teachers", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
                      const SizedBox(height: 8),
                      const Text("Upload faculty list via .xlsx file", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),

                      // File Picker UI
                      GestureDetector(
                        onTap: () => controller.pickExcelFile(),
                        child: _buildFilePickerBox(controller),
                      ),
                      const SizedBox(height: 25),

                      // Upload Button
                      _buildUploadButton(controller),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // --- Table Header ---
                _buildTableHeader(controller),
                const SizedBox(height: 15),

                // --- Table Data ---
                _buildTeacherDataTable(controller, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildFilePickerBox(TeacherController controller) {
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
          const Icon(Icons.upload_file_rounded, color: Color(0xFFFF9100)),
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

  Widget _buildUploadButton(TeacherController controller) {
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
                : const Text("Upload Faculty", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      )),
    );
  }

  Widget _buildTableHeader(TeacherController controller) {
    return Row(
      children: [
        const Icon(Icons.people_alt_rounded, color: Color(0xFFFF6D00)),
        const SizedBox(width: 10),
        const Text("Faculty List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
          child: Text("${controller.teachersList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  Widget _buildTeacherDataTable(TeacherController controller, BuildContext context) {
    return Obx(() {
      if (controller.teachersList.isEmpty) return const Text("No faculty records found.");
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
              columnSpacing: 35,
              headingRowHeight: 55,
              headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),
              columns: const [
                DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Designation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Department', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), // Naya Column
                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
              rows: controller.teachersList.map((teacher) {
                return DataRow(
                  cells: [
                    DataCell(Text(teacher['name'] ?? "N/A")),
                    DataCell(Text(teacher['designation'] ?? "N/A")),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(teacher['department'] ?? "N/A", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditTeacherDialog(context, teacher, controller)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => controller.deleteTeacher(teacher['_id'])),
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

  void _showEditTeacherDialog(BuildContext context, dynamic teacher, TeacherController controller) {
    // Purana data pehle se bhara hua aayega
    final nameEdit = TextEditingController(text: teacher['name']);
    final desigEdit = TextEditingController(text: teacher['designation']);
    final deptEdit = TextEditingController(text: teacher['department']);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Teacher",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
                ),
                const SizedBox(height: 20),

                // Name Field
                _buildEditTextField(nameEdit, "Teacher Name", Icons.person_outline),
                const SizedBox(height: 15),

                // Designation Field
                _buildEditTextField(desigEdit, "Designation", Icons.work_outline),
                const SizedBox(height: 15),

                // Department Field
                _buildEditTextField(deptEdit, "Department", Icons.business_outlined),

                const SizedBox(height: 25),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6D00),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => controller.updateTeacher(
                          teacher['_id'],
                          nameEdit.text,
                          desigEdit.text,
                          deptEdit.text,
                        ),
                        child: const Text("Update", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Dialog ke liye chota TextField helper
  Widget _buildEditTextField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF8E1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}