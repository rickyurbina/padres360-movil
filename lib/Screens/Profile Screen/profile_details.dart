import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Profile%20Screen/parent_profile.dart';
import 'package:Padres360/Screens/Profile%20Screen/teacher_profile.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  ProfileDetailsState createState() => ProfileDetailsState();
}

class ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: UserService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final user = snapshot.data!;
          return const TeacherProfileDetails();
        }
      },
    );
  }
}
