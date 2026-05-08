import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isResending = false;

  Future<void> _handleResend() async {
    setState(() => _isResending = true);
    // Mock network delay — in a real app this would call an API.
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isResending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification email sent. Please check your inbox.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AppRoutes.login,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card 1 — Verification pending
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.softBorder),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.paleSignalBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: AppColors.logisticsNavy,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Verification Pending',
                          style: AppTextStyles.headline,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "We've sent a verification link to your "
                          "student email. Please check your inbox to "
                          "activate your account.",
                          style: AppTextStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Card 2 — Why verify
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.paleSignalBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.softBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              color: AppColors.logisticsNavy,
                              size: 22,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Why verify your email?',
                              style: AppTextStyles.title,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Verification helps unlock trusted account '
                          'capabilities like RSVPing to exclusive events '
                          'and receiving priority notifications. Please '
                          'note that event publishing is reserved for '
                          'approved roles such as staff, club executives, '
                          'and class representatives.',
                          style: AppTextStyles.bodyMuted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Resend button
                  FilledButton.icon(
                    onPressed: _isResending ? null : _handleResend,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: _isResending
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      _isResending
                          ? 'Sending...'
                          : 'Resend Verification Email',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Footer hint
                  Text(
                    "Can't find the email? Check your spam folder or try "
                    "resending in 2 minutes.",
                    style: AppTextStyles.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}