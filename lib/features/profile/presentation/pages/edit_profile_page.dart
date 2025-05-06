import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_in/features/auth/presentation/components/my_button.dart';
import 'package:vibe_in/features/auth/presentation/components/my_text_field.dart';
import 'package:vibe_in/features/profile/domain/entities/profile_user.dart';

import '../cubits/profile_cubits.dart';
import '../cubits/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // text controller
  final nameTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final bioTextController = TextEditingController();

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = result.files.first.bytes;
        }
      });
    }
  }

  void updateProfile() {
    // profile cubits
    final profileCubits = context.read<ProfileCubits>();

    // prepare images and data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    // only update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubits.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }
    // nothing to update
    else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // nameTextController.text = widget.user.name;
    // usernameTextController.text = widget.user.username;
    // bioTextController.text = widget.user.bio;
  }

  @override
  void dispose() {
    nameTextController.dispose();
    usernameTextController.dispose();
    bioTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
          return Scaffold(
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Uploading...'),
                ],
              ),
            ),
          );
        } else {
          // edit form
          return buildEditForm();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditForm() {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // profile image
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child:
                  // display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                      :
                      // display selected image for web
                      (kIsWeb && webImage != null)
                      ? Image.memory(webImage!, fit: BoxFit.cover)
                      :
                      // no image selected -> display existing profile picture
                      CachedNetworkImage(
                        imageUrl: widget.user.profileImage,
                        // loading
                        placeholder:
                            (context, url) => Center(
                              child: const CircularProgressIndicator(),
                            ),
                        // error
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.person,
                              size: 75,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        // loaded
                        imageBuilder:
                            (context, imageProvider) =>
                                Image(image: imageProvider, fit: BoxFit.cover),
                      ),
            ),
            SizedBox(height: 10),
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                child: Text('Pick Image', style: TextStyle(color: Colors.blue)),
              ),
            ),

            SizedBox(height: 25),

            // // name
            // Text('Name'),
            // SizedBox(height: 5),
            // MyTextField(
            //   controller: nameTextController,
            //   hintText: widget.user.name,
            //   obscureText: false,
            // ),
            // SizedBox(height: 10),

            // // username
            // Text('Username'),
            // SizedBox(height: 5),
            // MyTextField(
            //   controller: usernameTextController,
            //   hintText: widget.user.username,
            //   obscureText: false,
            // ),
            // SizedBox(height: 10),

            // bio
            Text('Bio'),
            SizedBox(height: 5),
            MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ),

            const Spacer(),
            MyButton(onTap: updateProfile, text: 'Save'),
          ],
        ),
      ),
    );
  }
}
