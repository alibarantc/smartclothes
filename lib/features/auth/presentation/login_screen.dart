import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_text_field.dart';
import 'package:smartclothes/features/auth/presentation/forgot_password_screen.dart';
import 'package:smartclothes/features/auth/presentation/register_screen.dart';
import 'package:smartclothes/features/auth/presentation/widgets/auth_unconfigured_card.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

/// Screen allowing existing SmartClothes users to authenticate with email and password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen e-posta adresinizi girin.';
    }
    final email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi girin.';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = AuthService.instance;
    final result = await authService.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.errorMessage;
      });
    }
  }

  void _handleDemoMode() {
    AuthService.instance.enterDemoMode();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFirebaseConfigured = AuthService.instance.isFirebaseAvailable;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isFirebaseConfigured) ...[
                  const AuthUnconfiguredCard(),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text(
                  'Tekrar Hoş Geldiniz 👋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Akıllı gardırobunuza erişmek için bilgilerinizi girin.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                if (_errorMessage != null) ...[
                  SmartCard(
                    backgroundColor: colorScheme.errorContainer,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // E-posta
                SmartTextField(
                  controller: _emailController,
                  label: 'E-posta Adresi',
                  hintText: 'ornek@smartclothes.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                // Şifre
                SmartTextField(
                  controller: _passwordController,
                  label: 'Şifre',
                  hintText: 'Şifrenizi girin',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: AppSpacing.xs),

                // Şifremi Unuttum Bağlantısı
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: const Text('Şifremi Unuttum'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Giriş Yap Butonu
                SmartButton(
                  text: 'Giriş Yap',
                  icon: Icons.login_rounded,
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: AppSpacing.md),

                // Demo Mod Butonu
                SmartButton(
                  text: 'Demo Olarak Devam Et',
                  variant: SmartButtonVariant.outlined,
                  icon: Icons.explore_outlined,
                  onPressed: _handleDemoMode,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Kayıt Ol linki
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hesabınız yok mu?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: const Text('Hemen Kayıt Olun'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
