import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../view_models/controller/adminController/program_controller.dart';

class ProgramView extends StatelessWidget {
  const ProgramView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProgramController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPrograms(),
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
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 80, color: Colors.orange),
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
                      const Text("Program Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
                      const SizedBox(height: 8),
                      const Text("Define university departments and programs", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 25),

                      _buildTextField(controller.departmentNameController, "Enter Department", Icons.business_rounded),
                      const SizedBox(height: 15),
                      _buildTextField(controller.programNameController, "Enter Program", Icons.menu_book_rounded),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.addProgram(),
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
                                  : const Text("Save Program", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                _buildRecordsHeader(controller),
                const SizedBox(height: 15),

                Obx(() {
                  if (controller.programList.isEmpty) return const Text("No records found.");
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
                            DataColumn(label: Text('Department', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Program', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                          // DataTable ki Rows ke andar cells ko is se replace karein:
                          rows: controller.programList.map((prog) {
                            return DataRow(
                              cells: [
                                DataCell(Text(prog['department_name']?.toString() ?? "N/A")),
                                DataCell(Text(prog['program_name']?.toString() ?? "N/A")),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // Passing current values to dialog
                                        _showUpdateDialog(
                                            context,
                                            prog['_id'],
                                            prog['program_name'] ?? "",
                                            prog['department_name'] ?? "",
                                            controller
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller.deleteProgram(prog['_id']),
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
                }),
                SizedBox(height: 70,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFFF9100)),
        filled: true,
        fillColor: const Color(0xFFFFF8E1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFFF9100), width: 2)),
      ),
    );
  }

  Widget _buildRecordsHeader(ProgramController controller) {
    return Row(
      children: [
        const Icon(Icons.list_alt_rounded, color: Color(0xFFFF6D00)),
        const SizedBox(width: 10),
        const Text("Programs List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
          child: Text("${controller.programList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  // --- Updated Dialog Call ---
  void _showUpdateDialog(BuildContext context, String id, String oldName, String oldDept, ProgramController controller) {
    final nameEdit = TextEditingController(text: oldName);
    final deptEdit = TextEditingController(text: oldDept);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("Update Program", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(deptEdit, "Department", Icons.business),
            const SizedBox(height: 10),
            _buildTextField(nameEdit, "Program", Icons.book),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () => controller.updateProgram(id, nameEdit.text, deptEdit.text),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}