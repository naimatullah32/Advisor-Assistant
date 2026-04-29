import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../view_models/controller/adminController/session_controller.dart';

class SessionView extends StatelessWidget {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchSessions(),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),

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
                      const Text("Session Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
                      const SizedBox(height: 20),

                      // Session Name
                      _buildTextField(controller.sessionNameController, "Session Name (e.g. Spring 2026)", Icons.edit_calendar),
                      const SizedBox(height: 15),

                      // Start Date Picker
                      Obx(() => _buildDatePicker(context, "Start Date: ${controller.startDate.value}", () => controller.pickDate(context, true))),
                      const SizedBox(height: 15),

                      // End Date Picker
                      Obx(() => _buildDatePicker(context, "End Date: ${controller.endDate.value}", () => controller.pickDate(context, false))),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.addSession(),
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
                                  : const Text("Save Session", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // --- Records Table ---
                _buildRecordsHeader(controller),
                const SizedBox(height: 15),

                Obx(() {
                  if (controller.sessionList.isEmpty) return const Text("No sessions found.");
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
                          columnSpacing: 30,
                          headingRowHeight: 55,
                          headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),
                          columns: const [
                            DataColumn(label: Text('Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('End', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                          // DataTable ki rows ka updated code
                          rows: controller.sessionList.map((ses) {
                            return DataRow(
                              cells: [
                                DataCell(Text(ses['session_name'] ?? "")),
                                DataCell(Text(ses['start_date']?.toString().split('T')[0] ?? "")),
                                DataCell(Text(ses['end_date']?.toString().split('T')[0] ?? "")),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showSessionUpdateDialog(context, ses, controller),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller.deleteSession(ses['_id']),
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

  // --- Date Picker UI Helper ---
  Widget _buildDatePicker(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFFF9100)),
            const SizedBox(width: 15),
            Text(title.contains(":") && title.split(":")[1].trim().isEmpty ? title.split(":")[0] : title,
                style: const TextStyle(color: Colors.black87, fontSize: 16)),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFFF9100)),
        filled: true,
        fillColor: const Color(0xFFFFF8E1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRecordsHeader(SessionController controller) {
    return Row(
      children: [
        const Icon(Icons.history_edu, color: Color(0xFFFF6D00)),
        const SizedBox(width: 10),
        const Text("Session Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(20)),
          child: Text("${controller.sessionList.length} Total", style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  void _showSessionUpdateDialog(BuildContext context, dynamic session, SessionController controller) {
    final nameEdit = TextEditingController(text: session['session_name']);
    var sDateEdit = (session['start_date']?.toString().split('T')[0] ?? "").obs;
    var eDateEdit = (session['end_date']?.toString().split('T')[0] ?? "").obs;

    // Internal function for dialog date picking
    Future<void> pickEditDate(bool isStart) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        String formatted = DateFormat('yyyy-MM-dd').format(picked);
        if (isStart) sDateEdit.value = formatted; else eDateEdit.value = formatted;
      }
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("Update Session", style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameEdit,
                decoration: const InputDecoration(labelText: "Session Name", prefixIcon: Icon(Icons.edit)),
              ),
              const SizedBox(height: 15),
              Obx(() => ListTile(
                title: Text("Start: ${sDateEdit.value}"),
                trailing: const Icon(Icons.calendar_month, color: Colors.orange),
                onTap: () => pickEditDate(true),
                tileColor: Colors.orange.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
              const SizedBox(height: 10),
              Obx(() => ListTile(
                title: Text("End: ${eDateEdit.value}"),
                trailing: const Icon(Icons.calendar_month, color: Colors.orange),
                onTap: () => pickEditDate(false),
                tileColor: Colors.orange.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => controller.updateSession(session['_id'], nameEdit.text, sDateEdit.value, eDateEdit.value),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}