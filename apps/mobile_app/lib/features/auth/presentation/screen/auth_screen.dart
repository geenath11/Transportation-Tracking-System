import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import 'otp_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.length != 10 ||
        !phoneNumber.startsWith('0') ||
        !RegExp(r'^07\d{8}$').hasMatch(phoneNumber)) {
      _showMessage('Enter a valid Sri Lankan mobile number');
      return;
    }

    final formattedPhoneNumber = '+94${phoneNumber.substring(1)}';

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });
          } on FirebaseAuthException catch (e) {
            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });

            _showMessage(
              e.message ?? 'Automatic verification failed',
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });

          _showMessage(
            e.message ?? 'OTP verification failed',
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: formattedPhoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        e.message ?? 'Something went wrong',
      );
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
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen =
                MediaQuery.of(context).viewInsets.bottom > 0;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                'Cey Go',
                                style: AppTextStyles.bold.copyWith(
                                  fontSize: 65,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Smart Public Transportation System',
                                style: AppTextStyles.semiBold,
                              ),
                            ],
                          ),
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
                                  'Enter your mobile number to continue',
                                  style: AppTextStyles.semiBold,
                                ),
                                const SizedBox(height: 19),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your Number',
                                      counterText: '',
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(17),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(17),
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 19),
                                AppButton(
                                  height: 60,
                                  width: double.infinity,
                                  onPressed: _sendOTP,
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
                                    style:
                                    AppTextStyles.semiBold.copyWith(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.gpp_good,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "We'll send you an OTP to verify your number",
                                        style:
                                        AppTextStyles.semiBold.copyWith(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 30,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.semiBold.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By continuing, you agree to our\n',
                        ),
                        TextSpan(
                          text: 'Privacy Policy ',
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(text: 'and '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}