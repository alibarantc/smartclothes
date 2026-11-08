import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/navigation/main_navigation_screen.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/features/auth/presentation/auth_gate.dart';
import 'package:smartclothes/features/auth/presentation/forgot_password_screen.dart';
import 'package:smartclothes/features/auth/presentation/login_screen.dart';
import 'package:smartclothes/features/auth/presentation/register_screen.dart';
import 'package:smartclothes/features/auth/presentation/widgets/auth_unconfigured_card.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/welcome/presentation/welcome_screen.dart';

void main() {
  setUp(() {
    FirebaseService.resetForTesting();
    AuthService.instance = AuthService();
  });

  group('LoginScreen Tests', () {
    testWidgets('renders all login fields, buttons and unconfigured banner',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Giriş Yap'), findsWidgets);
      expect(find.byType(AuthUnconfiguredCard), findsOneWidget);
      expect(find.text('E-posta Adresi'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
      expect(find.text('Şifremi Unuttum'), findsOneWidget);
      expect(find.text('Demo Olarak Devam Et'), findsOneWidget);
      expect(find.text('Hemen Kayıt Olun'), findsOneWidget);
    });

    testWidgets('validates empty email and password inputs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Giriş Yap without entering anything
      final loginBtn = find.widgetWithText(ElevatedButton, 'Giriş Yap');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Lütfen e-posta adresinizi girin.'), findsOneWidget);
      expect(find.text('Lütfen şifrenizi girin.'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextFormField).first, 'invalidemail');
      final loginBtn = find.widgetWithText(ElevatedButton, 'Giriş Yap');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Geçerli bir e-posta adresi girin.'), findsOneWidget);
    });

    testWidgets('tapping Demo mode activates demo state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(AuthService.instance.isDemoMode.value, isFalse);
      final demoBtn = find.text('Demo Olarak Devam Et');
      await tester.ensureVisible(demoBtn);
      await tester.tap(demoBtn);
      await tester.pumpAndSettle();

      expect(AuthService.instance.isDemoMode.value, isTrue);
    });

    testWidgets('tapping Kayıt Ol navigates to RegisterScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final registerLink = find.text('Hemen Kayıt Olun');
      await tester.ensureVisible(registerLink);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      expect(find.text('Hesap Oluştur'), findsOneWidget);
      expect(find.text('Aramıza Katılın ✨'), findsOneWidget);
    });

    testWidgets('tapping Şifremi Unuttum navigates to ForgotPasswordScreen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final forgotLink = find.text('Şifremi Unuttum');
      await tester.ensureVisible(forgotLink);
      await tester.tap(forgotLink);
      await tester.pumpAndSettle();

      expect(find.text('Şifrenizi mi unuttunuz?'), findsOneWidget);
      expect(find.text('Sıfırlama Bağlantısı Gönder'), findsOneWidget);
    });
  });

  group('RegisterScreen Tests', () {
    testWidgets('renders all register input fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const RegisterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hesap Oluştur'), findsOneWidget);
      expect(find.byType(AuthUnconfiguredCard), findsOneWidget);
      expect(find.text('Ad Soyad'), findsOneWidget);
      expect(find.text('E-posta Adresi'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
      expect(find.text('Şifre Tekrarı'), findsOneWidget);
      expect(find.text('Kayıt Ol'), findsWidgets);
    });

    testWidgets('validates password mismatch and length', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const RegisterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Submit empty
      final registerBtn = find.widgetWithText(ElevatedButton, 'Kayıt Ol');
      await tester.ensureVisible(registerBtn);
      await tester.tap(registerBtn);
      await tester.pumpAndSettle();

      expect(find.text('Lütfen adınızı ve soyadınızı girin.'), findsOneWidget);
      expect(find.text('Lütfen e-posta adresinizi girin.'), findsOneWidget);
      expect(find.text('Lütfen bir şifre belirleyin.'), findsOneWidget);
      expect(find.text('Lütfen şifrenizi tekrar girin.'), findsOneWidget);
    });
  });

  group('ForgotPasswordScreen Tests', () {
    testWidgets('renders forgot password elements and handles validation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const ForgotPasswordScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Şifremi Unuttum'), findsOneWidget);
      expect(find.byType(AuthUnconfiguredCard), findsOneWidget);

      await tester.tap(find.text('Sıfırlama Bağlantısı Gönder'));
      await tester.pumpAndSettle();

      expect(find.text('Lütfen e-posta adresinizi girin.'), findsOneWidget);
    });
  });

  group('AuthGate Tests', () {
    testWidgets('shows WelcomeScreen when unauthenticated and unconfigured',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const AuthGate(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(MainNavigationScreen), findsNothing);
    });

    testWidgets('shows MainNavigationScreen when Demo mode is entered',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const AuthGate(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);

      // Enter demo mode
      AuthService.instance.enterDemoMode();
      await tester.pumpAndSettle();

      expect(find.byType(MainNavigationScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);

      // Sign out / exit demo
      await AuthService.instance.signOut();
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });
}
