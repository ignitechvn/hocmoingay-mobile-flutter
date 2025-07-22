# Contributing to Học Mỗi Ngày Mobile App

Cảm ơn bạn đã quan tâm đến việc đóng góp cho dự án Học Mỗi Ngày! 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## 🤝 Code of Conduct

Chúng tôi cam kết tạo ra một môi trường đóng góp thân thiện và tôn trọng. Vui lòng đọc và tuân thủ [Code of Conduct](CODE_OF_CONDUCT.md).

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: ^3.7.2
- **Dart**: ^3.7.2
- **IDE**: VS Code hoặc Android Studio
- **Git**: Latest version

### Setup Steps

1. **Fork the repository**
   ```bash
   # Fork trên GitHub, sau đó clone
   git clone https://github.com/YOUR_USERNAME/hocmoingay-mobile-flutter.git
   cd hocmoingay-mobile-flutter
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/hocmoingay/hocmoingay-mobile-flutter.git
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🛠️ Development Setup

### Environment Configuration

1. **Create environment file**
   ```bash
   cp lib/core/config/app_config.example.dart lib/core/config/app_config.dart
   ```

2. **Configure API endpoints**
   - Development: `https://dev-api.hocmoingay.com`
   - Staging: `https://staging-api.hocmoingay.com`
   - Production: `https://api.hocmoingay.com`

### Code Generation

Chạy code generation khi cần thiết:
```bash
# Generate all code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📝 Coding Standards

### Dart/Flutter Standards

- Tuân thủ [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Sử dụng [Flutter Lints](https://dart.dev/go/flutter-lints)
- Đảm bảo code coverage >80%

### File Naming

- **Screens**: `snake_case_screen.dart`
- **Widgets**: `snake_case_widget.dart`
- **Models**: `snake_case_model.dart`
- **Services**: `snake_case_service.dart`

### Code Organization

```dart
// 1. Imports (external packages first)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 2. Local imports
import '../models/user.dart';
import '../services/auth_service.dart';

// 3. Class definition
class UserProfileScreen extends StatefulWidget {
  // ...
}

// 4. Implementation
class _UserProfileScreenState extends State<UserProfileScreen> {
  // Constants
  static const double _padding = 16.0;
  
  // Variables
  late User _user;
  bool _isLoading = false;
  
  // Lifecycle methods
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  
  // Private methods
  Future<void> _loadUser() async {
    // Implementation
  }
  
  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Implementation
    );
  }
}
```

### Error Handling

```dart
// Always handle errors properly
try {
  final result = await apiService.fetchData();
  return result;
} on NetworkException catch (e) {
  logger.error('Network error: $e');
  throw NetworkFailure('Không thể kết nối mạng');
} on ValidationException catch (e) {
  logger.warning('Validation error: $e');
  throw ValidationFailure(e.fieldErrors);
} catch (e) {
  logger.error('Unexpected error: $e');
  throw UnknownFailure('Đã xảy ra lỗi không xác định');
}
```

## 📝 Commit Guidelines

Chúng tôi sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

### Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Examples

```bash
# Feature
feat(auth): add phone number validation

# Bug fix
fix(login): resolve password field not clearing after error

# Documentation
docs(readme): update installation instructions

# Refactoring
refactor(api): extract common API error handling

# Test
test(auth): add unit tests for login validation
```

## 🔄 Pull Request Process

### Before Submitting

1. **Update your fork**
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow coding standards
   - Add tests if applicable
   - Update documentation

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   flutter build apk --debug
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat(scope): your commit message"
   ```

### Pull Request Template

```markdown
## 📋 Description
Brief description of changes

## 🎯 Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## 🧪 Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed
- [ ] No console errors

## 📱 Screenshots (if applicable)
Add screenshots for UI changes

## ✅ Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

## 🧪 Testing

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/auth/login_test.dart

# With coverage
flutter test --coverage
```

### Test Guidelines

- **Unit Tests**: Test business logic
- **Widget Tests**: Test UI components
- **Integration Tests**: Test user flows
- **Mock Dependencies**: Use Mockito for external dependencies

### Example Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('LoginViewModel', () {
    late MockAuthService mockAuthService;
    late LoginViewModel viewModel;

    setUp(() {
      mockAuthService = MockAuthService();
      viewModel = LoginViewModel(mockAuthService);
    });

    test('should login successfully with valid credentials', () async {
      // Arrange
      when(mockAuthService.login(any, any))
          .thenAnswer((_) async => User(id: '1', name: 'Test'));

      // Act
      await viewModel.login('test@example.com', 'password');

      // Assert
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
    });
  });
}
```

## 📚 Documentation

### Code Documentation

```dart
/// Service for handling authentication operations.
/// 
/// This service provides methods for user login, registration,
/// and token management.
class AuthService {
  /// Authenticates a user with email and password.
  /// 
  /// Returns a [User] object if authentication is successful.
  /// Throws [AuthenticationException] if credentials are invalid.
  /// 
  /// Example:
  /// ```dart
  /// final user = await authService.login('user@example.com', 'password');
  /// ```
  Future<User> login(String email, String password) async {
    // Implementation
  }
}
```

### API Documentation

- Document all public APIs
- Include examples
- Explain error cases
- Update when API changes

## 🐛 Bug Reports

### Bug Report Template

```markdown
## 🐛 Bug Description
Clear description of the bug

## 🔄 Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## ✅ Expected Behavior
What should happen

## ❌ Actual Behavior
What actually happens

## 📱 Environment
- OS: [e.g. Android 12, iOS 15]
- Device: [e.g. Samsung Galaxy S21, iPhone 13]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.7.2]

## 📸 Screenshots
Add screenshots if applicable

## 📋 Additional Context
Any other context about the problem
```

## 💡 Feature Requests

### Feature Request Template

```markdown
## 💡 Feature Description
Clear description of the feature

## 🎯 Problem Statement
What problem does this feature solve?

## 💭 Proposed Solution
How should this feature work?

## 🔄 Alternative Solutions
Other ways to solve the problem

## 📱 Mockups/Screenshots
Add mockups if applicable

## 📋 Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3
```

## 📞 Getting Help

- **Issues**: [GitHub Issues](https://github.com/hocmoingay/hocmoingay-mobile-flutter/issues)
- **Discussions**: [GitHub Discussions](https://github.com/hocmoingay/hocmoingay-mobile-flutter/discussions)
- **Email**: dev@hocmoingay.com

## 🙏 Recognition

Tất cả contributors sẽ được ghi nhận trong:
- [Contributors page](https://github.com/hocmoingay/hocmoingay-mobile-flutter/graphs/contributors)
- Release notes
- Project documentation

---

**Cảm ơn bạn đã đóng góp cho Học Mỗi Ngày! 🎓✨** 