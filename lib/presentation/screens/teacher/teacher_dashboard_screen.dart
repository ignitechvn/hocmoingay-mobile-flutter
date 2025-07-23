import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _ClassesTab(),
    const _StudentsTab(),
    const _NotificationsTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

// Simple tab implementations
class _ClassesTab extends StatelessWidget {
  const _ClassesTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lớp học của tôi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('Danh sách lớp học')),
    );
  }
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Học sinh'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('Danh sách học sinh')),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('Danh sách thông báo')),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cá nhân'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('Thông tin cá nhân')),
    );
  }
}
