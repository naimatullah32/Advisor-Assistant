import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/controller/adminController/course_controller.dart';

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchCourses(),
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
                _buildCourseDataTable(controller, context),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard(CourseController controller) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: const Color(0xFFFF6D00).withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const Text("Import Courses", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
          const SizedBox(height: 30),
          GestureDetector(onTap: () => controller.pickExcelFile(), child: _buildFilePickerBox(controller)),
          const SizedBox(height: 25),
          _buildUploadButton(controller),
        ],
      ),
    );
  }

  Widget _buildFilePickerBox(CourseController controller) {
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
          Expanded(child: Obx(() => Text(controller.fileName.value, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepOrange)))),
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

  Widget _buildUploadButton(CourseController controller) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.uploadToDB(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                : const Text("Upload Courses", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      )),
    );
  }

  Widget _buildTableHeader(CourseController controller) {
    return Row(
      children: [
        const Icon(Icons.library_books, color: Color(0xFFFF6D00)),
        const SizedBox(width: 10),
        const Text("Course List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
          child: Text("${controller.courseList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  Widget _buildCourseDataTable(CourseController controller, BuildContext context) {
    return Obx(() {
      if (controller.courseList.isEmpty) return const Text("No courses found.");
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
                DataColumn(label: Text('Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cr. Hrs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), // Naya Column
                DataColumn(label: Text('Program', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
              rows: controller.courseList.map((course) {
                return DataRow(
                  cells: [
                    DataCell(Text(course['course_code'] ?? "N/A")),
                    DataCell(Text(course['course_title'] ?? "N/A")),
                    // Credit Hours Cell with Orange Badge Style
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course['credit_hrs']?.toString() ?? "0",
                        style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Text(course['program'] ?? "N/A")),
                    DataCell(Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditCourseDialog(context, course, controller)
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteCourse(course['_id'])
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
    });
  }

  void _showEditCourseDialog(BuildContext context, dynamic course, CourseController controller) {
    // Purana data pehle se bhara hua aayega
    final codeEdit = TextEditingController(text: course['course_code']);
    final titleEdit = TextEditingController(text: course['course_title']);
    final creditEdit = TextEditingController(text: course['credit_hrs']?.toString());
    final programEdit = TextEditingController(text: course['program']);

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
                  "Edit Course Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
                ),
                const SizedBox(height: 20),

                // Fields (Wahi orange theme)
                _buildEditTextField(codeEdit, "Course Code", Icons.qr_code),
                const SizedBox(height: 15),
                _buildEditTextField(titleEdit, "Course Title", Icons.book_outlined),
                const SizedBox(height: 15),
                _buildEditTextField(creditEdit, "Credit Hours", Icons.timer_outlined),
                const SizedBox(height: 15),
                _buildEditTextField(programEdit, "Program", Icons.school_outlined),

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
                        onPressed: () {
                          controller.updateCourse(
                            course['_id'],
                            {
                              "course_code": codeEdit.text,
                              "course_title": titleEdit.text,
                              "credit_hrs": int.parse(creditEdit.text),
                              "program": programEdit.text,
                            },
                          );
                        },
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

// Dialog ke liye wahi TextField helper jo Teacher View mein tha
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