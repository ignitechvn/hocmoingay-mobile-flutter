import 'package:go_router/go_router.dart';

import '../../../presentation/screens/auth/login/login_screen.dart';
import '../../../presentation/screens/auth/register/register_screen.dart';
import '../../../presentation/screens/auth/register/congratulations_screen.dart';
import '../../../presentation/screens/auth/reset_password/reset_password_screen.dart';
import '../../../presentation/screens/auth/verify_otp/verify_otp_screen.dart';
import '../../../presentation/screens/auth/forgot_password/forgot_password_screen.dart';
import '../../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../../presentation/screens/onboarding/role_selection_screen.dart';
import '../../../presentation/screens/student/dashboard/student_dashboard_screen.dart';
import '../../../presentation/screens/common/notification_screen.dart';
import '../../../presentation/screens/student/classroom/classroom_details_screen.dart';
import '../../presentation/screens/student/chapter/student_chapters_screen.dart';
import '../../presentation/screens/student/chapter/student_chapter_details_screen.dart';
import '../../../presentation/screens/teacher/teacher_dashboard_screen.dart';
import '../../../presentation/screens/teacher/resources/subject_details_screen.dart';
import '../../../presentation/screens/teacher/resources/topic_templates_screen.dart';
import '../../../presentation/screens/teacher/resources/topic_details_screen.dart';
import '../../../presentation/widgets/auth_wrapper.dart';
import '../../../data/dto/subject_dto.dart';
import '../../../data/dto/bank_topic_dto.dart';
import '../../../core/constants/app_constants.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const login = '/login';
  static const register = '/register';
  static const congratulations = '/congratulations';
  static const resetPassword = '/reset-password';
  static const verifyOtp = '/verify-otp';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const notifications = '/notifications';
  static const classroomDetails = '/classroom-details';
  static const chapters = '/chapters';
  static const chapterDetails = '/chapter-details';
  static const teacherDashboard = '/teacher-dashboard';
  static const subjectDetails = '/subject-details';
  static const topicTemplates = '/topic-templates';
  static const topicDetails = '/topic-details';
  static const root = '/';

  static final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.congratulations,
        builder: (context, state) => const CongratulationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra != null &&
              extra.containsKey('phone') &&
              extra.containsKey('role')) {
            // If we have phone and role, this is from forgot password flow
            return const ResetPasswordScreen();
          }
          // Default reset password screen
          return const ResetPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra != null && extra.containsKey('phone')) {
            return VerifyOtpScreen(phone: extra['phone'] as String);
          }
          // Fallback - redirect to forgot password
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const CommonNotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.classroomDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final classroomId = extra?['classroomId'] as String?;
          if (classroomId != null) {
            return ClassroomDetailsScreen(classroomId: classroomId);
          }
          return const StudentDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.chapters,
        builder: (context, state) {
          print('DEBUG: Chapters route called');
          final extra = state.extra as Map<String, dynamic>?;
          print('DEBUG: Extra data: $extra');
          final classroomId = extra?['classroomId'] as String?;
          print('DEBUG: ClassroomId: $classroomId');
          if (classroomId != null) {
            print('DEBUG: Returning ChaptersScreen');
            return StudentChaptersScreen(classroomId: classroomId);
          }
          print('DEBUG: Returning StudentDashboardScreen as fallback');
          return const StudentDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.chapterDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final chapterId = extra?['chapterId'] as String?;
          if (chapterId != null) {
            return StudentChapterDetailsScreen(chapterId: chapterId);
          }
          return const StudentDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherDashboard,
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.subjectDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final subject = extra?['subject'] as SubjectResponseDto?;
          if (subject != null) {
            return SubjectDetailsScreen(subject: subject);
          }
          return const TeacherDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.topicTemplates,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final subject = extra?['subject'] as SubjectResponseDto?;
          if (subject != null) {
            return TopicTemplatesScreen(subject: subject);
          }
          return const TeacherDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.topicDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final topic = extra?['topic'] as BankTopicWithCountDto?;
          if (topic != null) {
            return TopicDetailsScreen(topic: topic);
          }
          return const TeacherDashboardScreen();
        },
      ),
    ],
    initialLocation: AppRoutes.root,
    redirect: (context, state) {
      // Redirect to onboarding if not authenticated
      return null;
    },
  );
}
