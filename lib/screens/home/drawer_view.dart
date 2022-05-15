import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/screens/home/refer_and_earn_view.dart';
import 'package:timevictor/screens/payment/cash_bonus_view.dart';
import 'package:timevictor/screens/payment/payment_transactions_view.dart';
import 'package:timevictor/screens/home/profile_screen.dart';
import 'package:timevictor/screens/settings/settings.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/services/dynamic_links_services.dart';
import 'package:timevictor/utils/helper.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';
import 'package:timevictor/widgets/wallet_balance.dart';

class DrawerView extends StatelessWidget {
  final Function reload;

  const DrawerView({Key key, this.reload}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    try {
      await Authentication().signOut();
      SharedPref sharedPref = SharedPref();
      sharedPref.saveUID('');
      sharedPref.savePhoneNumber('');
      await sharedPref.saveUserInfo(
        UserInfo(
          name: '',
          email: '',
          age: '',
          gender: '',
          profilePicURL: '',
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign Out Failed',
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context);
    final user = provider.user;
    final uid = provider.uid;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: kAppBackgroundColor,
                gradient: LinearGradient(
                  colors: [kAppBackgroundColor, kAppBackgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [0.5, 0.8],
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ProfilePicWidget(
                      profilePicURL: user.profilePicURL,
                      radius: 40.0,
                      heroTag: 'profilePicTag',
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 150.0,
                          child: Text(
                            user.name != null
                                ? user.name.toUpperCase()
                                : 'TV User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          provider.userPhoneNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.user,
              color: kAppBackgroundColor,
            ),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wallet'),
                WalletBalanceWidget(),
              ],
            ),
            leading: Icon(
              Icons.account_balance_wallet,
              color: kAppBackgroundColor,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentTransactions(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.gift, color: Colors.redAccent),
            title: Text('Cash Bonus'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CashBonusPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: kAppBackgroundColor,
            ),
            title: Text("Settings"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppSettings(),
                ),
              ).then((value) {
                print('Just Poped on Screen');
                reload();
              });
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: kAppBackgroundColor,
            ),
            title: Text('Refer and Earn'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReferAndEarn(
                    uid: uid,
                  ),
                ),
              );
            },
          ),
          AboutListTile(
            icon: Icon(
              Icons.info_outline,
              color: kAppBackgroundColor,
            ),
            applicationName: 'Time Victor',
            applicationIcon: ImageIcon(
              AssetImage('assets/images/tvLogoFinal.png'),
              color: Color(0xffe05e63),
              size: 50.0,
            ),
            applicationVersion: 'version ${provider.appVersion}',
            dense: true,
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.fileSignature,
              color: kAppBackgroundColor,
            ),
            title: Text('Terms & Conditions'),
            onTap: () async {
              await Helper.openTermAndConditionLink(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: kAppBackgroundColor,
            ),
            title: Text("Logout"),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
