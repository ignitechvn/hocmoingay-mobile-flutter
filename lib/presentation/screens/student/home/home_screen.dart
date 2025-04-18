import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {

  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Xin chào, Nguyễn Văn A'),
              trailing: Icon(Icons.notifications_none),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Lớp học của bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // Class cards
            _ClassCard(subject: 'Toán học', time: 'Thứ 2, 7:30 - 9:00', grade: 'Lớp 10A1'),
            _ClassCard(subject: 'Vật lý', time: 'Thứ 3, 9:30 - 11:00', grade: 'Lớp 10A1'),

            const Spacer(),

            // Bottom Nav (tĩnh)
            const Divider(height: 1),
            NavigationBar(
              selectedIndex: 0,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.school), label: 'Lớp học'),
                NavigationDestination(icon: Icon(Icons.notifications), label: 'Thông báo'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Hồ sơ'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String subject;
  final String time;
  final String grade;

  const _ClassCard({
    required this.subject,
    required this.time,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 4),
            Text(time),
          ],
        ),
        trailing: Text(grade),
      ),
    );
  }
}
