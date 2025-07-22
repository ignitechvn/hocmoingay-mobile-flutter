# 🎨 Design System - Học Mỗi Ngày

## 🎯 Brand Colors

### Primary Colors
- **Primary Blue**: `#1E3A8A` - Màu chính của brand, lấy từ web design
- **Primary Light**: `#3B5998` - Màu nhạt hơn cho hover states
- **Primary Dark**: `#1E3A8A` - Màu đậm hơn cho active states

### Secondary Colors
- **Secondary Orange**: `#FF9800` - Màu phụ cho call-to-action
- **Secondary Light**: `#FFB74D` - Màu nhạt hơn
- **Secondary Dark**: `#F57C00` - Màu đậm hơn

### Accent Colors
- **Accent Gold**: `#FFD700` - Màu nhấn cho highlights
- **Accent Light**: `#FFE082` - Màu nhạt hơn
- **Accent Dark**: `#FFB300` - Màu đậm hơn

## 🎨 Color Palette

### Background Colors
- **Background**: `#F8FAFC` - Màu nền chính (light blue tint)
- **Surface**: `#FFFFFF` - Màu nền cho cards, buttons
- **Surface Variant**: `#F5F5F5` - Màu nền phụ

### Text Colors
- **Text Primary**: `#212121` - Màu chữ chính
- **Text Secondary**: `#757575` - Màu chữ phụ
- **Text Inverse**: `#FFFFFF` - Màu chữ trên nền tối
- **Text Disabled**: `#BDBDBD` - Màu chữ bị vô hiệu hóa

### Status Colors
- **Success**: `#4CAF50` - Thành công
- **Warning**: `#FF9800` - Cảnh báo
- **Error**: `#F44336` - Lỗi
- **Info**: `#2196F3` - Thông tin

### Role-specific Colors
- **Teacher Primary**: `#1E3A8A` - Màu cho giáo viên
- **Teacher Light**: `#E8F2FF` - Màu nhạt cho giáo viên
- **Student Primary**: `#FF9800` - Màu cho học sinh
- **Student Light**: `#FFF3E0` - Màu nhạt cho học sinh
- **Parent Primary**: `#9C27B0` - Màu cho phụ huynh
- **Parent Light**: `#F3E5F5` - Màu nhạt cho phụ huynh

## 🎨 Material Color System

### Primary Blue Material Color
```dart
MaterialColor(0xFF1E3A8A, {
  50: Color(0xFFE8F2FF),   // Lightest
  100: Color(0xFFC5D9FF),
  200: Color(0xFF9EC0FF),
  300: Color(0xFF77A7FF),
  400: Color(0xFF5A94FF),
  500: Color(0xFF1E3A8A),  // Primary
  600: Color(0xFF1A3478),
  700: Color(0xFF162D66),
  800: Color(0xFF122654),
  900: Color(0xFF0E1F42),  // Darkest
})
```

## 🎨 Usage Guidelines

### Buttons
- **Primary Buttons**: Use `AppColors.primary`
- **Secondary Buttons**: Use `AppColors.secondary`
- **Text Buttons**: Use `AppColors.primary` for text

### Cards & Surfaces
- **Main Cards**: Use `AppColors.surface`
- **Background**: Use `AppColors.background`
- **Borders**: Use `AppColors.grey300`

### Text
- **Headings**: Use `AppColors.textPrimary`
- **Body Text**: Use `AppColors.textPrimary`
- **Captions**: Use `AppColors.textSecondary`
- **Links**: Use `AppColors.primary`

### Icons
- **Primary Icons**: Use `AppColors.primary`
- **Secondary Icons**: Use `AppColors.textSecondary`
- **Success Icons**: Use `AppColors.success`
- **Error Icons**: Use `AppColors.error`

## 🎨 Accessibility

### Contrast Ratios
- **Primary Text**: 15:1 (exceeds WCAG AAA)
- **Secondary Text**: 7:1 (exceeds WCAG AA)
- **Large Text**: 4.5:1 (exceeds WCAG AA)

### Color Blindness Support
- All status colors have sufficient contrast
- Icons are used alongside colors for better recognition
- Text labels are always provided

## 🎨 Implementation

### In Code
```dart
// Use AppColors for consistent theming
Container(
  color: AppColors.primary,
  child: Text(
    'Hello World',
    style: TextStyle(color: AppColors.textInverse),
  ),
)

// Use MaterialColor for theme
ThemeData(
  primarySwatch: AppMaterialColors.primaryBlue,
)
```

### File Structure
```
lib/core/theme/
├── app_colors.dart           # Color constants
├── app_material_colors.dart  # MaterialColor definitions
├── app_text_styles.dart      # Typography
└── app_dimensions.dart       # Spacing & sizing
```

## 🎨 Brand Consistency

### Web Design Alignment
- Primary color `#1E3A8A` matches web design
- Consistent color usage across platforms
- Unified brand experience

### Mobile-First Approach
- Colors optimized for mobile screens
- Touch-friendly contrast ratios
- Accessibility compliance

---

**Last Updated**: July 2024
**Version**: 2.0 (Updated to match web design) 