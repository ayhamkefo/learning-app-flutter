import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'components/big_user_card.dart';
import 'components/icon_style.dart';
import 'components/settings_group.dart';
import 'components/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  Future lgout(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(
        select: 'Settings',
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            BigUserCard(
              backgroundColor: const Color.fromARGB(218, 71, 89, 167),
              userName: Provider.of<Auth>(context, listen: false).user!.name,
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Modify",
                onTap: () {},
              ),
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about the",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: "Confirm your sign up pleas",
                      btnCancelOnPress: () {
                        Navigator.pop(context);
                      },
                      btnOkOnPress: () {
                        lgout(context);
                        if (Provider.of<Auth>(context, listen: false)
                            .isLoading) {
                          const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
                SettingsItem(
                  iconStyle: IconStyle(
                    backgroundColor: Colors.red,
                  ),
                  onTap: () {},
                  icons: Icons.delete_outline_outlined,
                  title: "Delete account",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
