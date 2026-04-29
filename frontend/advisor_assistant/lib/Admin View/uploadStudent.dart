import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../view_models/controller/adminController/upload_student_controller.dart';

class UploadStudentScreen extends StatelessWidget {
  const UploadStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.put(StudentController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      // AppBar for better FYP look
      // RefreshIndicator taake list manually refresh ho saky
      body: RefreshIndicator(
        onRefresh: () => controller.fetchStudents(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header mein jahan error aa raha tha
                // Lottie.asset(
                //   'assets/lottie/Sucess.json', // Local path use karein
                //   height: 120,
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Icon(Icons.cloud_upload, size: 80, color: Colors.orange); // Backup icon
                //   },
                // ),
                const SizedBox(height: 20),

                // --- Main Upload Card ---
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6D00).withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Import Students",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100)),
                      ),
                      const SizedBox(height: 8),
                      const Text("Select your .xlsx file to sync data", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: () => controller.pickExcelFile(),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              const Icon(Icons.description_rounded, color: Color(0xFFFF9100)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(() => Text(
                                  controller.fileName.value,
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepOrange),
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9100),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.center,
                                child: const Text("Browse", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.uploadToDB(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            shadowColor: const Color(0xFFFF9100).withOpacity(0.4),
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
                                  : const Text("Upload Student",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // --- Database List ---
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 10),
                    const Text("Database Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
                      child: Text("${controller.studentsList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                    )),
                  ],
                ),
                const SizedBox(height: 15),

                // --- Database Records Table Section ---
                // --- Database Records Section ---
                // --- Database Records Section ---
                Obx(() {
                  if (controller.studentsList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text("No records found in MongoDB", style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Horizontal Scroll Enabled
                        child: DataTable(
                          // Design Customization
                          columnSpacing: 40,
                          headingRowHeight: 55,
                          dataRowHeight: 60,
                          headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)), // Solid Orange Header

                          // Header Columns
                          columns: const [
                            DataColumn(label: Text('Full Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Student ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Section', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Semester', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                          ],

                          // Data Rows
                          rows: controller.studentsList.map((std) {
                            return DataRow(
                              cells: [
                                DataCell(Text(std['std_name']?.toString() ?? "", style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(Text(std['std_id']?.toString() ?? "N/A")),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(std['section'] ?? "-", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataCell(Text(std['semester_no']?.toString() ?? "-")),
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
}