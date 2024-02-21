import 'package:flutter/material.dart';
import 'package:uridachi/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
 
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 185, 222, 207),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4FD9B8), // Start color of the gradient
                    Color(0xFFE3FFCD), // End color of the gradient
                  ],
                ),
              ),
                 
            ),


            
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DrawerHeader(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 64,
                      ),
                      
                      ),

                       MyListTile(
                icon: Icons.home, 
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
                ),
              
               MyListTile(
                icon: Icons.person, 
                text: 'P R O F I L E',
                onTap: onProfileTap,
                ),

                MyListTile(
                icon: Icons.person, 
                text: 'L O G O U T',
                onTap: onSignOut,
                ),



                  ],

                ),


                

             


          ],
        ),


  
      ),

    );
  }
}