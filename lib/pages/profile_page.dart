import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diploma_16_10/components/text_box.dart';
import 'package:diploma_16_10/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState()=>_ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!; 
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  bool isSwitched = false;  // Default to off/false


  Future<void> editField (String field) async{
    String newValue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text("Edit " + field, style: TextStyle(color: Colors.white),),
      content: TextField(
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter new $field",
          hintStyle: TextStyle(color: Colors.grey)
        ),
        onChanged: (value){
          newValue = value;
        }
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context), 

        ),

        TextButton(
          child: Text('Save', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.of(context).pop(newValue), 
        ),
      ],
    ),
    );
    if(newValue.trim().length > 0){
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }

  }

  // Future<String> uploadImage(String path, XFile){
  //   try{

  //   } on FirebaseException catch (e){
  //     throw FirebaseException(e.code).message;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: const Text('Profile Page'),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(child: Text('No data available for this user.'));
            }
            final userData = snapshot.data!.data() as Map<String, dynamic>;
      
            return ListView(
              children: [
                  const SizedBox(height: 50,),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 20),
                    
                  ),
                  const SizedBox(height: 50,),
      
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
      
                MyTextBox(
                  text: userData['username'], 
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),
                MyTextBox(
                  text: userData['bio'], 
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Transactions',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SwitchListTile(
                title: Text('Dark Mode', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                value: isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    isSwitched = value;
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  });
                },
                activeColor: Colors.white,
              ),
              ],
            );
          }
        )
    );
  }
  
}
