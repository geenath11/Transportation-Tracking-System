<<<<<<< Updated upstream

=======
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import 'name_setup_page.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _otpTimer;
  bool _isLoading = false;
  int _remainingSeconds = 59;
  static final PinTheme _defaultPinTheme = PinTheme(
    width: 55,
    height: 60,
    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: Colors.transparent),
    ),
  );
  static final PinTheme _focusedPinTheme = PinTheme(
    width: 55,
    height: 60,
    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AppColors.primary, width: 2),
    ),
  );
  static final PinTheme _submittedPinTheme = PinTheme(
    width: 55,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(17),
    ),
  );

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _remainingSeconds = 59;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    if (_isLoading) return;
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showMessage('Enter the 6-digit OTP');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NameSetupPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage(e.message ?? 'Invalid OTP. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('Something went wrong. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 40),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.translationValues(
                          0,
                          keyboardOpen ? -80 : 0,
                          0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Verify Your Number',
                              style: AppTextStyles.bold.copyWith(fontSize: 30),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'We sent a 6-digit OTP to',
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.phoneNumber,
                              style: AppTextStyles.bold.copyWith(
                                color: AppColors.primary,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 19),
                            Pinput(
                              controller: _otpController,
                              length: 6,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              defaultPinTheme: _defaultPinTheme,
                              focusedPinTheme: _focusedPinTheme,
                              submittedPinTheme: _submittedPinTheme,
                              enabled: !_isLoading,
                              onCompleted: (value) {
                                _verifyOTP();
                              },
                            ),
                            const SizedBox(height: 19),
                            AppButton(
                              height: 60,
                              width: double.infinity,
                              onPressed: _verifyOTP,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Continue',
                                      style: AppTextStyles.semiBold.copyWith(
                                        fontSize: 17,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Resend OTP in ',
                                  style: AppTextStyles.semiBold.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _formattedTime,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'For your security, never share your OTP with anyone',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: _isLoading
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Wrong number? '),
                                        TextSpan(
                                          text: 'Change number',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
