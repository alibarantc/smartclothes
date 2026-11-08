import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_text_field.dart';
import 'package:smartclothes/features/auth/presentation/widgets/auth_unconfigured_card.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

/// Password recovery screen for SmartClothes users.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = AuthService.instance;
    final result = await authService.sendPasswordResetEmail(
      email: _emailController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFirebaseConfigured = AuthService.instance.isFirebaseAvailable;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _emailSent ? _buildSuccessView(context) : _buildFormView(context, isFirebaseConfigured, colorScheme),
        ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context,
    bool isFirebaseConfigured,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isFirebaseConfigured) ...[
            const AuthUnconfiguredCard(),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            'Şifrenizi mi unuttunuz?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Kayıtlı e-posta adresinizi girin. Şifrenizi sıfırlamanız için size bir bağlantı göndereceğiz.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
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
          SmartTextField(
            controller: _emailController,
            label: 'E-posta Adresi',
            hintText: 'ornek@smartclothes.com',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: _validateEmail,
            onSubmitted: (_) => _handleResetPassword(),
          ),
          const SizedBox(height: AppSpacing.xl),
          SmartButton(
            text: 'Sıfırlama Bağlantısı Gönder',
            icon: Icons.send_rounded,
            isLoading: _isLoading,
            onPressed: _handleResetPassword,
          ),
          const SizedBox(height: AppSpacing.md),
          SmartButton(
            text: 'Giriş Ekranına Dön',
            variant: SmartButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Talep Alındı',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Eğer bu e-posta adresiyle sistemimizde kayıtlı bir hesap bulunuyorsa, '
          'şifre sıfırlama talimatları kısa süre içinde adresinize iletilecektir.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        SmartButton(
          text: 'Giriş Ekranına Dön',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
