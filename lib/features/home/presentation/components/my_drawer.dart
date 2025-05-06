import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_in/features/home/presentation/components/my_drawer_tile.dart';

import '../../../auth/presentation/cubits/auth_cubits.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              // home tile
              MyDrawerTile(
                title: 'H O M E',
                icon: Icons.home_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),

              // devider line
              Divider(color: Theme.of(context).colorScheme.secondary),

              // profile tile
              MyDrawerTile(
                title: 'P R O F I L E',
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.of(context).pop();
                  // get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  // navigate to profile
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

              Divider(color: Theme.of(context).colorScheme.secondary),

              // search tile
              MyDrawerTile(
                title: 'S E A R C H',
                icon: Icons.search_rounded,
                onTap: () {},
              ),

              Divider(color: Theme.of(context).colorScheme.secondary),

              // settings tile
              MyDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.settings_rounded,
                onTap: () {},
              ),

              const Spacer(),

              // logout tile
              MyDrawerTile(
                title: 'L O G O U T',
                icon: Icons.logout_rounded,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
