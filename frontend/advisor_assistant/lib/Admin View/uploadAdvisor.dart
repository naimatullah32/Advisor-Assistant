import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../view_models/controller/adminController/upload_advisor_controller.dart'; // Apna path check karlein

class UploadAdvisorScreen extends StatelessWidget {
  const UploadAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Advisor controller initialize kiya
    final AdvisorController controller = Get.put(AdvisorController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchAdvisors(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header Animation
                // Lottie.asset(
                //   'assets/lottie/upload_animation.json', // Apna asset path check karein
                //   height: 120,
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Icon(Icons.person_search_rounded, size: 80, color: Colors.orange);
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
                        "Import Advisors",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100)),
                      ),
                      const SizedBox(height: 8),
                      const Text("Select .xlsx file to sync advisors", style: TextStyle(color: Colors.grey)),
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
                                  : const Text("Upload Advisor",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // --- Database List Header ---
                Row(
                  children: [
                    const Icon(Icons.badge_rounded, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 10),
                    const Text("Current Advisors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
                      child: Text("${controller.advisorsList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                    )),
                  ],
                ),
                const SizedBox(height: 15),

                // --- Advisor Data Table ---
                Obx(() {
                  if (controller.advisorsList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text("No advisors found in MongoDB", style: TextStyle(color: Colors.grey)),
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
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 40,
                          headingRowHeight: 55,
                          dataRowHeight: 60,
                          headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),

                          columns: const [
                            DataColumn(label: Text('Advisor Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Section', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Teacher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                            DataColumn(label: Text('Batch ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                          ],

                          rows: controller.advisorsList.map((adv) {
                            return DataRow(
                              cells: [
                                DataCell(Text(adv['name']?.toString() ?? "", style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(adv['section'] ?? "-", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                // Teacher name comes from populate
                                DataCell(Text(adv['teacher']?['name']?.toString() ?? "Unassigned")),
                                DataCell(Text(adv['batch']?.toString() ?? "N/A")),
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