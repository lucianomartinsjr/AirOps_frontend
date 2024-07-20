import 'package:flutter/material.dart';
import 'components/admin_button.dart';
import 'components/admin_header.dart';
import 'games_screen.dart';
import 'modalities_screen.dart';
import 'users_screen.dart';
import 'classes_screen.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdminHeader(),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                AdminButton(
                  title: 'Gerenciar\nClasses\nJogadores',
                  icon: Icons.manage_accounts,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ClassesScreen(),
                    ));
                  },
                ),
                AdminButton(
                  title: 'Gerenciar\nmodalidades',
                  icon: Icons.category,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ModalitiesScreen(),
                    ));
                  },
                ),
                AdminButton(
                  title: 'Gerenciar\nJogos',
                  icon: Icons.sports_esports,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GamesAdminScreen(),
                    ));
                  },
                ),
                AdminButton(
                  title: 'Gerenciar\nUsuarios',
                  icon: Icons.people,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UsersScreen(),
                    ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
