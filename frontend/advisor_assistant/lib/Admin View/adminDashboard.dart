import 'package:advisor_assistant/Admin%20View/batchView.dart';
import 'package:advisor_assistant/Admin%20View/courseAllocationView.dart';
import 'package:advisor_assistant/Admin%20View/courseView.dart';
import 'package:advisor_assistant/Admin%20View/feeSubmissionView.dart';
import 'package:advisor_assistant/Admin%20View/programView.dart';
import 'package:advisor_assistant/Admin%20View/sessionView.dart';
import 'package:advisor_assistant/Admin%20View/uploadAdvisor.dart';
import 'package:advisor_assistant/Admin%20View/uploadTeacherView.dart';
import 'package:advisor_assistant/Teacher%20View/HomeView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../res/routes/routes_name.dart';
import '../view_models/controller/adminController/admin_dashboard_controller.dart';
import '../view_models/controller/user_preference/user_prefrence_view_model.dart';
import '../Admin View/uploadStudent.dart'; // Apna path sahi check kar lein

class AdminHomeView extends StatelessWidget {
  AdminHomeView({super.key});

  final controller = Get.put(AdminDashboardController());
  final UserPreference userPreference = UserPreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Light Orange Tint
      drawer: _buildDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9100), Color(0xFFFF6D00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(() => Text(
          controller.currentView.value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        // Switch case sari 15 values ke liye
        switch (controller.currentView.value) {
          case 'Home': return _buildHomeView();
          case 'Upload Student': return const UploadStudentScreen();
          case 'Add Advisor': return const UploadAdvisorScreen();
          case 'Batch': return const BatchView();
          case 'Program': return const ProgramView();
          case 'Session': return const SessionView();
          case 'Fee Schedule': return const FeeScheduleView();
          case 'Add Teacher': return const UploadTeacherView();
          case 'Course Allocation': return const AllocationView();
          case 'Course': return const CourseView();
        // Baki screens aap yahan map kar sakte hain
          default:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction_rounded, size: 80, color: Colors.orange.withOpacity(0.5)),
                  const SizedBox(height: 10),
                  Text(
                    '${controller.currentView.value} View\nComing Soon...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
        }
      }),
    );
  }

  // ===================== HOME VIEW (DASHBOARD CARDS) =====================
  Widget _buildHomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Admin,", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const Text("System Statistics",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
          const SizedBox(height: 25),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _statCard("Total Students", "1,200", Icons.people_alt_rounded),
              _statCard("Total Teachers", "45", Icons.school_rounded),
              _statCard("Active Courses", "32", Icons.menu_book_rounded),
              _statCard("Fee Collected", "85%", Icons.payments_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 40),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // ===================== DRAWER (ALL 15 VALUES) =====================
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          /// HEADER
          FutureBuilder(
            future: userPreference.getUser(),
            builder: (context, snapshot) {
              String role = snapshot.data?.role ?? "Admin";
              String firstLetter = role.isNotEmpty ? role[0].toUpperCase() : "A";

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFF9100), Color(0xFFFF6D00)]),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Text(firstLetter, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFFFF6D00))),
                    ),
                    const SizedBox(height: 12),
                    Text(role.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text("University Panel", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              );
            },
          ),

          /// ALL 15 MENU ITEMS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                _drawerItem(Icons.home_rounded, 'Home'),
                _drawerItem(Icons.person_add_rounded, 'Add Advisor'),
                _drawerItem(Icons.cloud_upload_rounded, 'Upload Student'),
                _drawerItem(Icons.school_rounded, 'Add Teacher'),
                _drawerItem(Icons.account_balance_wallet_rounded, 'Fee Schedule'),
                _drawerItem(Icons.payments_rounded, 'Fee Submission'),
                _drawerItem(Icons.app_registration_rounded, 'Enrollment'),
                _drawerItem(Icons.assignment_ind_rounded, 'Course Allocation'),
                _drawerItem(Icons.upload_file_rounded, 'Upload Result'),
                _drawerItem(Icons.event_available_rounded, 'Session'),
                _drawerItem(Icons.menu_book_rounded, 'Program'),
                _drawerItem(Icons.groups_rounded, 'Batch'),
                _drawerItem(Icons.schedule_rounded, 'Time Table'),
                _drawerItem(Icons.book_rounded, 'Course'),
                _drawerItem(Icons.fact_check_rounded, 'Upload Attendance'),

                const Divider(height: 30, thickness: 1),

                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: const Text("LogOut", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  onTap: () => _showLogoutDialog(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return Obx(() {
      bool isSelected = controller.currentView.value == title;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFFF9100).withOpacity(0.15) : Colors.transparent,
        ),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -2), // Items ko thora compact karne ke liye
          leading: Icon(icon, color: isSelected ? const Color(0xFFFF6D00) : Colors.blueGrey, size: 22),
          title: Text(
              title,
              style: TextStyle(
                  color: isSelected ? const Color(0xFFFF6D00) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14
              )
          ),
          onTap: () {
            controller.changeView(title);
            Get.back();
          },
        ),
      );
    });
  }

  // ===================== LOGOUT DIALOG =====================
  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/Exit.json',
                height: 120,
              ),
              const Text("Are you sure?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("you want to end this session?", textAlign: TextAlign.center),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("No", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        userPreference.removeUser().then((value) {
                          Get.offAllNamed(RouteName.loginView);
                        });
                      },
                      child: const Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}