import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import 'otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final TextEditingController phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
  Future<void> _sendOTP() async {

    String phoneNumber = phoneController.text.trim();


    if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid phone number"),
        ),
      );
      return;
    }


    String formattedPhoneNumber =
        "+94${phoneNumber.substring(1)}";


    await _auth.verifyPhoneNumber(

      phoneNumber: formattedPhoneNumber,


      verificationCompleted: (PhoneAuthCredential credential) async {

        await _auth.signInWithCredential(credential);

      },


      verificationFailed: (FirebaseAuthException e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? "OTP verification failed",
            ),
          ),
        );

      },


      codeSent: (String verificationId, int? resendToken) {


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 40),

                              Text(
                                "Cey Go",
                                style: AppTextStyles.bold.copyWith(
                                  fontSize: 65,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Smart Public Transportation System",
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
                                  "Enter your mobile number to continue",
                                  style: AppTextStyles.semiBold,
                                ),

                                const SizedBox(height: 19),

                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],

                                    maxLength: 10,

                                    decoration: InputDecoration(
                                      hintText: "Enter your Number",
                                      counterText: "",

                                      prefixIcon: const Icon(Icons.phone),

                                      filled: true,
                                      fillColor: Colors.grey.shade100,

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                        borderSide: BorderSide.none,
                                      ),

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
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

                                  child: Text(
                                    "Continue",
                                    style: AppTextStyles.semiBold.copyWith(
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
                                        style: AppTextStyles.semiBold.copyWith(
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
                          text: "By continuing, you agree to our\n",
                        ),
                        TextSpan(
                          text: "Privacy Policy ",
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(text: "and "),
                        TextSpan(
                          text: "Terms of Service",
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
