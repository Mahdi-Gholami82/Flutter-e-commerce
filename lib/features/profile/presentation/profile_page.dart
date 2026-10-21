import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String route = "/profile";

  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("Profile Page")));
}
