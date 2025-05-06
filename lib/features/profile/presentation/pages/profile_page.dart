import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_in/features/auth/domain/entities/app_user.dart';
import 'package:vibe_in/features/profile/presentation/cubits/profile_state.dart';
import 'package:vibe_in/features/profile/presentation/pages/edit_profile_page.dart';

import '../../../auth/presentation/cubits/auth_cubits.dart';
import '../components/bio_box.dart';
import '../cubits/profile_cubits.dart';

class ProfilePage extends StatefulWidget {
  final String? uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubits>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubits, ProfileState>(
      builder: (context, state) {
        // profile loaded
        if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                user.username,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  // email
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        // profile picture
                        CachedNetworkImage(
                          imageUrl: user.profileImage,
                          // loading
                          placeholder:
                              (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          // error
                          errorWidget:
                              (context, url, error) => Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                                size: 50,
                              ),
                          // image loaded
                          imageBuilder:
                              (context, imageProvider) => Container(
                                width: 75,
                                height: 75,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // name
                            Text(
                              user.name,
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            // email
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // bio
                  BioBox(text: user.bio),

                  // post
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        'Posts',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(body: Center(child: Text('No profile found')));
        }
      },
    );
  }
}
