import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/controller/adminController/fee_schedule_controller.dart';

class FeeScheduleView extends StatelessWidget {
  const FeeScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeeScheduleController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // --- Main Entry Card ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  const Text("Fee Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFE65100))),
                  const SizedBox(height: 25),

                  // Session Dropdown (Session + Start Date Year)
                  _buildDropdownTile(
                    icon: Icons.history_edu,
                    child: Obx(() => DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Session"),
                      underline: const SizedBox(),
                      value: controller.selectedSessionId.value.isEmpty ? null : controller.selectedSessionId.value,
                      items: controller.sessionList.map((s) {
                        // Date se year extract kar rahe hain: e.g. "Fall" + "2026"
                        String year = s['start_date'] != null ? s['start_date'].toString().split('-')[0] : "";
                        return DropdownMenuItem(
                            value: s['_id'].toString(),
                            child: Text("${s['session_name']} $year")
                        );
                      }).toList(),
                      onChanged: (v) => controller.selectedSessionId.value = v!,
                    )),
                  ),
                  const SizedBox(height: 15),

                  // Program Dropdown
                  _buildDropdownTile(
                    icon: Icons.school_rounded,
                    child: Obx(() => DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Program"),
                      underline: const SizedBox(),
                      value: controller.selectedProgramId.value.isEmpty ? null : controller.selectedProgramId.value,
                      items: controller.programList.map((p) => DropdownMenuItem(value: p['_id'].toString(), child: Text(p['program_name']))).toList(),
                      onChanged: (v) => controller.selectedProgramId.value = v!,
                    )),
                  ),
                  const SizedBox(height: 15),

                  // Installment Dropdown with Add/Delete
                  _buildDropdownTile(
                    icon: Icons.account_balance_wallet_rounded,
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() => DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: controller.selectedInstallment.value,
                            items: controller.installmentOptions.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                            onChanged: (v) => controller.selectedInstallment.value = v!,
                          )),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.orange, size: 20),
                          onPressed: () => _showAddInstallmentDialog(controller),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Date Picker (Height fix like textfields)
                  GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: _buildDropdownTile(
                      icon: Icons.calendar_month_rounded,
                      child: Obx(() => Text(
                        controller.lastDate.value.isEmpty ? "Select Last Date" : controller.lastDate.value,
                        style: TextStyle(color: controller.lastDate.value.isEmpty ? Colors.grey[600] : Colors.black87),
                      )),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Amount Field
                  _buildTextField(controller.amountController, "Enter Amount", Icons.payments_rounded),
                  const SizedBox(height: 25),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6D00),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                      ),
                      onPressed: controller.isLoading.value ? null : () => controller.saveFee(),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Fee Structure", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // --- Records Table (Session Style Design) ---
            _buildTableSection(controller, context),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildDropdownTile({required IconData icon, required Widget child}) {
    return Container(
      height: 60, // Fixed height to match textfield
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 22),
          const SizedBox(width: 15),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildTableSection(FeeScheduleController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          child: Text("Recent Schedules", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        Obx(() => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color(0xFFFF9100)),
                columnSpacing: 25,
                columns: const [
                  DataColumn(label: Text('Installment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Last Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
                // DataTable ki rows ka part
                rows: controller.feeList.map((fee) {
                  return DataRow(
                    cells: [
                      // Installment Name (e.g., 1st Installment)
                      DataCell(Text(
                          fee['installment_no'] ?? "N/A",
                          style: const TextStyle(fontWeight: FontWeight.w600)
                      )),

                      // Amount
                      DataCell(Text(
                          "Rs. ${fee['amount']}",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                      )),

                      // Date (Formatted)
                      DataCell(Text(fee['last_date']?.toString().split('T')[0] ?? "N/A")),

                      // Actions (Edit & Delete)
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_note, color: Colors.blue, size: 26),
                            onPressed: () => _showUpdateDialog(context, fee, controller),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 26),
                            onPressed: () => controller.deleteFee(fee['_id']),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        )),
      ],
    );
  }

  // --- Add Installment Dialog ---
  void _showAddInstallmentDialog(FeeScheduleController controller) {
    final newInstallmentCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Manage Installments", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite, // Dialog width fix
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newInstallmentCtrl,
                decoration: InputDecoration(
                  hintText: "Enter New (e.g. 5th Installment)",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.orange),
                    onPressed: () {
                      if (newInstallmentCtrl.text.isNotEmpty) {
                        controller.addInstallment(newInstallmentCtrl.text.trim());
                        newInstallmentCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Tap to remove:", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Obx lazmi hai taake remove foran nazar aaye
              Obx(() => Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.installmentOptions.map((opt) => InputChip(
                  label: Text(opt, style: const TextStyle(fontSize: 11)),
                  onDeleted: () => controller.removeInstallment(opt), // Delete icon par click
                  deleteIconColor: Colors.red,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                )).toList(),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  // --- Update Dialog (Same as Session Design) ---
  void _showUpdateDialog(BuildContext context, dynamic fee, FeeScheduleController controller) {
    final amountEdit = TextEditingController(text: fee['amount'].toString());
    var dateEdit = (fee['last_date']?.toString().split('T')[0] ?? "").obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("Edit Schedule", style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(amountEdit, "Amount", Icons.money),
            const SizedBox(height: 15),
            Obx(() => GestureDetector(
              onTap: () async {
                DateTime? p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (p != null) dateEdit.value = DateFormat('yyyy-MM-dd').format(p);
              },
              child: _buildDropdownTile(icon: Icons.calendar_today, child: Text(dateEdit.value)),
            )),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => controller.updateFeeSchedule(
                fee['_id'], amountEdit.text, fee['installment_no'], dateEdit.value, fee['program']['_id'], fee['session']['_id']
            ),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}