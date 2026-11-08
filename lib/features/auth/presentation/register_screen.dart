import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_text_field.dart';
import 'package:smartclothes/features/auth/presentation/widgets/auth_unconfigured_card.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

/// User registration screen for creating a new SmartClothes account.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen adınızı ve soyadınızı girin.';
    }
    return null;
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
      return 'Lütfen bir şifre belirleyin.';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi tekrar girin.';
    }
    if (value != _passwordController.text) {
      return 'Şifreler birbiriyle eşleşmiyor.';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = AuthService.instance;
    final result = await authService.registerWithEmailAndPassword(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      // Registration succeeded — AuthGate or Pop will transition to main flow
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFirebaseConfigured = AuthService.instance.isFirebaseAvailable;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Oluştur'),
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
                  'Aramıza Katılın ✨',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Dolabınızı dijitalleştirip tarzınıza özel kombinleri keşfedin.',
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

                // Ad Soyad
                SmartTextField(
                  controller: _nameController,
                  label: 'Ad Soyad',
                  hintText: 'Örn: Deniz Yılmaz',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: AppSpacing.md),

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
                  hintText: 'En az 6 karakter',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                // Şifre Tekrar
                SmartTextField(
                  controller: _confirmPasswordController,
                  label: 'Şifre Tekrarı',
                  hintText: 'Şifrenizi tekrar girin',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onSubmitted: (_) => _handleRegister(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Kayıt Ol Butonu
                SmartButton(
                  text: 'Kayıt Ol',
                  icon: Icons.person_add_rounded,
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
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

                // Zaten hesabı var mı linki
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten hesabınız var mı?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Giriş Yapın'),
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
