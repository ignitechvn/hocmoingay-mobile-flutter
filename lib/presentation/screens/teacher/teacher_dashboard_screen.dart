import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/notification_screen.dart';
import '../common/profile_screen.dart';
import '../../../providers/notification/notification_providers.dart';
import 'dashboard/tabs/teacher_classes_tab.dart';
import 'resources/teacher_resources_screen.dart';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const TeacherClassesTab(),
    const TeacherResourcesScreen(),
    const CommonNotificationScreen(),
    const CommonProfileScreen(),
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
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.school), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                Consumer(
                  builder: (context, ref, child) {
                    final unreadCountAsync = ref.watch(unreadCountProvider);
                    return unreadCountAsync.when(
                      data: (unreadCount) {
                        if (unreadCount.count > 0) {
                          return Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount.count > 99
                                    ? '99+'
                                    : '${unreadCount.count}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
            label: '',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
