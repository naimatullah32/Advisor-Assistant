import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../res/components/DropDownTile.dart';
import '../res/routes/routes_name.dart';
import '../view_models/controller/Advisor Controller/AdvisorDashboardController.dart';
import '../view_models/controller/user_preference/user_prefrence_view_model.dart';


class AdvisorHomeView extends StatelessWidget {
  AdvisorHomeView({super.key});

  final controller = Get.put(AdvisorHomeController());
  UserPreference userPreference = UserPreference();

  @override
  Widget build(BuildContext context) {

    return Obx(() {

      Widget bodyContent;

      switch (controller.currentView.value) {

        case 'Home':
          bodyContent = const Center(child: Text('Home View'));
          break;

        case 'Meeting Schedule':
          bodyContent = const Center(child: Text('Meeting Schedule View'));
          break;

        case 'Submit Complaint':
          bodyContent = const Center(child: Text('Submit Complaint View'));
          break;

        case 'View Student':
          bodyContent = _buildStudentView();
          break;

        case 'Fee Structure':
          bodyContent = const Center(child: Text('Fee Structure'));
          break;

        case 'Fee Submission':
          bodyContent = const Center(child: Text('Fee Submission'));
          break;

        case 'View Result':
          bodyContent = const Center(child: Text('View Result'));
          break;

        case 'View Attendance':
          bodyContent = const Center(child: Text('View Attendance'));
          break;

        default:
          bodyContent = const Center(child: Text('Select an option'));
      }

      return Scaffold(
        drawer: _buildDrawer(),
        appBar: AppBar(
          title: Text(controller.currentView.value),
        ),
        body: bodyContent,
      );
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Muhammad Ali'),
            accountEmail: Text('Advisor'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          _drawerItem(Icons.home, 'Home'),
          _drawerItem(Icons.schedule, 'Meeting Schedule'),
          _drawerItem(Icons.report, 'Submit Complaint'),
          _drawerItem(Icons.group, 'View Student'),
          _drawerItem(Icons.attach_money, 'Fee Structure'),
          _drawerItem(Icons.payment, 'Fee Submission'),
          _drawerItem(Icons.menu_book_rounded, 'View Result'),
          _drawerItem(Icons.file_copy_rounded, 'View Attendance'),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.red,),
            title: Text("LogOut",style: TextStyle(color: Colors.red),),
              onTap: () {
                userPreference.removeUser().then((value) {
                  Get.offAllNamed(RouteName.loginView);
                });
              }
          )
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return Obx(() => ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: controller.currentView.value == title,
      onTap: () {
        controller.changeView(title);
        Get.back();
      },
    ));
  }

  Widget _buildStudentView() {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// FILTER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [

                /// Batch
                Obx(() => dropdownTile(
                  icon: Icons.calendar_today,
                  label: "Batch",
                  value: controller.selectedBatch.value,
                  items: ['2022-2026', '2023-2027'],
                  onChanged: controller.changeBatch,
                )),

                const SizedBox(height: 12),

                /// Program
                Obx(() => dropdownTile(
                  icon: Icons.menu_book,
                  label: "Program",
                  value: controller.selectedProgram.value,
                  items: ['BSCS', 'BBA'],
                  onChanged: controller.changeProgram,
                )),

                const SizedBox(height: 12),

                /// Section
                Obx(() => dropdownTile(
                  icon: Icons.groups,
                  label: "Section",
                  value: controller.selectedSection.value,
                  items: ['A', 'B', 'C'],
                  onChanged: controller.changeSection,
                )),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// TABLE
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => DataTable(
                  headingRowColor:
                  MaterialStateProperty.all(Colors.grey.shade200),
                  columns: const [
                    DataColumn(label: Text('Reg')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Father Name')),
                    DataColumn(label: Text('Contact')),
                  ],
                  rows: controller.students
                      .map(
                        (student) => DataRow(
                      cells: [
                        DataCell(Text(student['reg']!)),
                        DataCell(Text(student['name']!)),
                        DataCell(Text(student['father']!)),
                        DataCell(Text(student['contact']!)),
                      ],
                    ),
                  )
                      .toList(),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
