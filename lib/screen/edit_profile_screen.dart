import 'package:flutter/material.dart';
import '../model/user_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  const EditProfileScreen({super.key, required this.userProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController profilePictureController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userProfile.name);
    emailController = TextEditingController(text: widget.userProfile.email);
    profilePictureController = TextEditingController(text: widget.userProfile.profilePicture);
  }

  void saveProfile() {
    widget.userProfile.name = nameController.text;
    widget.userProfile.email = emailController.text;
    widget.userProfile.profilePicture = profilePictureController.text;

    Navigator.pop(context);  // Return to the previous screen (UserProfileScreen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: profilePictureController,
              decoration: const InputDecoration(labelText: "Profile Picture URL"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
