import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import '../../../passenger/presentation/screen/map_search_page.dart';
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });


  final List<_NavItem> items = const [

    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: "Home",
    ),

    _NavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: "Search",
    ),

    _NavItem(
      icon: Icons.confirmation_num_outlined,
      activeIcon: Icons.confirmation_num,
      label: "Tickets",
    ),

    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: "Profile",
    ),

  ];


  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 22,
      ),


      child: Container(

        height: 62,


        decoration: BoxDecoration(

          color: Colors.white.withOpacity(0.92),


          borderRadius:
          BorderRadius.circular(80),


          boxShadow: [

            BoxShadow(

              color:
              Colors.black.withOpacity(0.15),


              blurRadius: 10,


              spreadRadius: 1,


              offset:
              const Offset(0, 15),

            ),


            BoxShadow(

              color:
              Colors.black.withOpacity(0.05),


              blurRadius: 10,


              offset:
              const Offset(0, -2),

            ),

          ],


        ),



        child: ClipRRect(

          borderRadius:
          BorderRadius.circular(32),


          child: Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,


            children:

            List.generate(

              items.length,


                  (index){


                final bool selected =
                    currentIndex == index;



                return GestureDetector(


                  behavior:
                  HitTestBehavior.opaque,


                  onTap: (){

                    onTap(index);

                  },



                  child: AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds: 500,
                    ),


                    curve:
                    Curves.easeOutCubic,



                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 25,

                      vertical: 4,

                    ),



                    decoration:

                    BoxDecoration(

                      color:

                      selected

                          ?

                      AppColors.primary
                          .withOpacity(0.12)

                          :

                      Colors.transparent,



                      borderRadius:

                      BorderRadius.circular(25),


                    ),




                    child: Column(


                      mainAxisAlignment:
                      MainAxisAlignment.center,



                      children: [



                        AnimatedScale(

                          scale:
                          selected ? 1.4 : 1.0,


                          duration:
                          const Duration(
                            milliseconds: 100,
                          ),


                          child: Icon(

                            selected

                                ?

                            items[index].activeIcon

                                :

                            items[index].icon,


                            size: 26,


                            color:

                            selected

                                ?

                            AppColors.primary

                                :

                            Colors.grey.shade600,


                          ),

                        ),



                        const SizedBox(height: 4),




                        AnimatedDefaultTextStyle(

                          duration:
                          const Duration(
                            milliseconds: 200,
                          ),


                          style:

                          TextStyle(

                            fontSize: 12,


                            fontWeight:

                            selected

                                ?

                            FontWeight.w600

                                :

                            FontWeight.w400,


                            color:

                            selected

                                ?

                            AppColors.primary

                                :

                            Colors.grey.shade500,


                          ),



                          child:

                          Text(

                            items[index].label,

                          ),



                        ),


                      ],


                    ),


                  ),


                );


              },


            ),


          ),


        ),


      ),


    );

  }

}




class _NavItem {


  final IconData icon;


  final IconData activeIcon;


  final String label;



  const _NavItem({

    required this.icon,

    required this.activeIcon,

    required this.label,

  });


}