import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import 'name_setup_page.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                          Column(children: [const SizedBox(height: 40)]),

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
                                  "Verify Your Number",
                                  style: AppTextStyles.bold.copyWith(
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "We sent a 6-digit OTP to",
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "071 234 5678",
                                  style: AppTextStyles.bold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 19),
                                Pinput(
                                  length: 5,

                                  keyboardType: TextInputType.number,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],

                                  defaultPinTheme: PinTheme(
                                    width: 55,
                                    height: 60,

                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,

                                      borderRadius: BorderRadius.circular(17),

                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),

                                  focusedPinTheme: PinTheme(
                                    width: 55,
                                    height: 60,

                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),

                                      borderRadius: BorderRadius.circular(17),

                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),

                                  submittedPinTheme: PinTheme(
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
                                  ),

                                  onCompleted: (value) {
                                    print("Entered number: $value");
                                  },
                                ),
                                const SizedBox(height: 19),
                                AppButton(
                                  height: 60,
                                  width: double.infinity,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NameSetupPage(),
                                      ),
                                    );
                                  },

                                  child: Text(
                                    "Continue",
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
                                      "Resend OTP in ",
                                      style: AppTextStyles.semiBold.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    Text(
                                      "00:47",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 25),

                                    const SizedBox(height: 5),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),

                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.08,
                                        ), // light blue background

                                        borderRadius: BorderRadius.circular(14),

                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 1.2,
                                        ),
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          Icon(
                                            Icons.lock_outline,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),

                                          const SizedBox(width: 8),

                                          Flexible(
                                            child: Text(
                                              "For your security, never share your OTP with anyone",

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

                                    GestureDetector(
                                      onTap: () {
                                        // Navigate back to phone number screen
                                      },

                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),

                                          children: [
                                            const TextSpan(
                                              text: "Wrong number? ",
                                            ),

                                            TextSpan(
                                              text: "Change number",
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
              ],
            );
          },
        ),
      ),
    );
  }
}
