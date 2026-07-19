import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:transportation_tracking_system/features/auth/presentation/screen/otp_screen.dart';
import 'package:transportation_tracking_system/features/auth/presentation/screen/permission_setup_page.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';


class NameSetupPage extends StatefulWidget {
  const NameSetupPage({super.key});

  @override
  State<NameSetupPage> createState() => _NameSetupPageState();
}


class _NameSetupPageState extends State<NameSetupPage> {

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  bool showIntroText = true;


  @override
  void initState() {
    super.initState();


    firstNameFocus.addListener(updateAnimation);
    lastNameFocus.addListener(updateAnimation);

  }


  void updateAnimation() {

    setState(() {

      showIntroText =
          !firstNameFocus.hasFocus &&
              !lastNameFocus.hasFocus;

    });

  }



  @override
  void dispose() {

    firstNameFocus.dispose();
    lastNameFocus.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
              bottom: 20,
            ),


            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,


              children: [


                Align(

                  alignment: Alignment.topRight,


                  child: TextButton(

                    onPressed: () {

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const PermissionSetupPage(),

                        ),

                      );

                    },


                    child: Text(

                      "Maybe Later",

                      style: AppTextStyles.bold.copyWith(

                        color: AppColors.primary,

                      ),

                    ),

                  ),

                ),




                const SizedBox(height: 20),




                Center(

                  child: Column(

                    children: [


                      Text(

                        "Cey Go",

                        style: AppTextStyles.bold.copyWith(

                          fontSize: 65,

                          color: AppColors.primary,

                        ),

                      ),




                      const SizedBox(height: 10),




                      Text(

                        "Smart Journeys, Better Connections",

                        textAlign: TextAlign.center,

                        style: AppTextStyles.semiBold.copyWith(

                          fontSize: 16,

                        ),

                      ),



                      const SizedBox(height: 50),




                      AnimatedSwitcher(

                        duration:
                        const Duration(milliseconds: 350),



                        child: showIntroText

                            ? Column(

                          key: const ValueKey("intro"),

                          children: [


                            Text(

                              "Let’s personalize your experience",

                              textAlign: TextAlign.center,

                              style: AppTextStyles.semiBold.copyWith(

                                fontSize: 22,

                              ),

                            ),



                            const SizedBox(height: 20),




                            Text(

                              "Add your name so we can make your\n"
                                  "journey more personal",

                              textAlign: TextAlign.center,


                              style: AppTextStyles.semiBold.copyWith(

                                fontSize: 16,

                                color: Colors.grey,

                              ),

                            ),


                          ],

                        )


                            : const SizedBox(

                          key: ValueKey("empty"),

                        ),

                      ),


                    ],

                  ),

                ),





                AnimatedContainer(

                  duration:
                  const Duration(milliseconds: 350),

                  curve: Curves.easeInOut,


                  margin: EdgeInsets.only(

                    top: showIntroText ? 40 : 10,

                  ),



                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children: [



                      Text(

                        "What should we call you?",

                        style: AppTextStyles.bold.copyWith(

                          fontSize: 22,

                        ),

                      ),




                      const SizedBox(height: 20),





                      Text(

                        "First Name",

                        style: AppTextStyles.bold,

                      ),




                      const SizedBox(height: 5),





                      TextField(

                        focusNode: firstNameFocus,


                        inputFormatters: [

                          FilteringTextInputFormatter.allow(

                            RegExp(r'[a-zA-Z ]'),

                          ),

                        ],



                        decoration: InputDecoration(

                          hintText:
                          "Enter your first name",



                          prefixIcon:
                          const Icon(Icons.person_outline),



                          filled: true,

                          fillColor:
                          Colors.grey.shade100,



                          border:
                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(16),

                            borderSide:
                            BorderSide.none,

                          ),



                          focusedBorder:
                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(16),

                            borderSide:
                            BorderSide(

                              color:
                              AppColors.primary,

                              width: 2,

                            ),

                          ),

                        ),

                      ),




                      const SizedBox(height: 15),




                      Text(

                        "Last Name",

                        style: AppTextStyles.bold,

                      ),




                      const SizedBox(height: 5),





                      TextField(

                        focusNode: lastNameFocus,


                        inputFormatters: [

                          FilteringTextInputFormatter.allow(

                            RegExp(r'[a-zA-Z ]'),

                          ),

                        ],



                        decoration: InputDecoration(

                          hintText:
                          "Enter your last name",



                          prefixIcon:
                          const Icon(Icons.person_outline),



                          filled: true,

                          fillColor:
                          Colors.grey.shade100,



                          border:
                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(16),

                            borderSide:
                            BorderSide.none,

                          ),



                          focusedBorder:
                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(16),

                            borderSide:
                            BorderSide(

                              color:
                              AppColors.primary,

                              width: 2,

                            ),

                          ),

                        ),

                      ),





                      const SizedBox(height: 25),





                      AppButton(

                        height: 60,

                        width: double.infinity,


                        onPressed: () {

                          PermissionSetupPage();

                        },


                        child: Text(

                          "Continue",

                          style:
                          AppTextStyles.semiBold.copyWith(

                            fontSize: 17,

                          ),

                        ),

                      ),



                    ],

                  ),

                ),



              ],

            ),

          ),

        ),

      ),

    );

  }

}