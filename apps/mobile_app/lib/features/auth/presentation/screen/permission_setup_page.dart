import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class PermissionSetupPage extends StatefulWidget {
  const PermissionSetupPage({super.key});

  @override
  State<PermissionSetupPage> createState() =>
      _PermissionSetupPageState();
}


class _PermissionSetupPageState extends State<PermissionSetupPage> {


  Future<void> requestPermissions() async {

    await Permission.location.request();

    await Permission.notification.request();


    if (!mounted) return;


  }



  Widget permissionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {

    return Container(

      padding: const EdgeInsets.all(16),


      decoration: BoxDecoration(

        color: AppColors.primary.withOpacity(0.08),

        borderRadius: BorderRadius.circular(18),


        border: Border.all(

          color: AppColors.primary.withOpacity(0.4),

        ),

      ),


      child: Row(

        children: [


          Container(

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(14),

            ),


            child: Icon(

              icon,

              color: AppColors.primary,

              size: 28,

            ),

          ),


          const SizedBox(width: 15),



          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                Text(

                  title,

                  style: AppTextStyles.bold.copyWith(

                    fontSize: 17,

                  ),

                ),



                const SizedBox(height: 5),



                Text(

                  description,

                  style: AppTextStyles.semiBold.copyWith(

                    color: Colors.grey,

                    fontSize: 13,

                  ),

                ),


              ],

            ),

          ),


        ],

      ),

    );

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: SafeArea(


        child: Padding(


          padding: const EdgeInsets.all(24),



          child: Column(


            children: [



              const SizedBox(height: 30),




              Text(

                "Cey Go",

                style: AppTextStyles.bold.copyWith(

                  fontSize: 60,

                  color: AppColors.primary,

                ),

              ),




              const SizedBox(height: 35),




              Text(

                "Let's improve your\ntravel experience",

                textAlign: TextAlign.center,


                style: AppTextStyles.bold.copyWith(

                  fontSize: 25,

                ),

              ),




              const SizedBox(height: 15),




              Text(

                "Allow access to provide better journeys,\n"
                    "real-time updates and smarter travel.",


                textAlign: TextAlign.center,


                style: AppTextStyles.semiBold.copyWith(

                  color: Colors.grey,

                  fontSize: 15,

                ),

              ),





              const SizedBox(height: 40),




              permissionCard(

                icon: Icons.location_on_outlined,

                title: "Location Access",

                description:
                "Find nearby buses and get accurate arrival times.",

              ),




              const SizedBox(height: 18),





              permissionCard(

                icon: Icons.notifications_none,

                title: "Notification Access",

                description:
                "Receive trip updates, delays and booking alerts.",

              ),




              const Spacer(),





              AppButton(

                height: 60,

                width: double.infinity,


                onPressed: requestPermissions,


                child: Text(

                  "Allow Access",

                  style: AppTextStyles.semiBold.copyWith(

                    fontSize: 17,

                  ),

                ),

              ),




              TextButton(

                onPressed: () {




                },


                child: Text(

                  "Maybe Later",

                  style: AppTextStyles.bold.copyWith(

                    color: AppColors.primary,

                  ),

                ),

              ),




            ],

          ),

        ),

      ),

    );

  }

}