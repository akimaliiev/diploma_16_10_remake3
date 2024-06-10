import 'package:diploma_16_10/components/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;
  final void Function()? onStatisticsTap;
  final void Function()? onLoanCalculatorTap;
  const MyDrawer({super.key, required this.onProfileTap, required this.onLogoutTap, required this.onStatisticsTap, required this.onLoanCalculatorTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                onTap: ()=> Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person, 
                text: 'P R O F I L E',
                onTap: onProfileTap,
               ),
               MyListTile(
                icon: Icons.numbers, 
                text: 'S T A T I S T I C S',
                onTap: onStatisticsTap,
               ),
              MyListTile(
                icon: Icons.calculate_outlined, 
                text: 'L O A N  C A L C U L A T O R',
                onTap: onLoanCalculatorTap,
               ),
              
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: MyListTile(
              icon: Icons.logout, 
              text: 'L O G O U T',
              onTap: onLogoutTap,
                    ),
          ),
      ]),
    );
  }
}