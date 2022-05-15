import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/screens/home/edit_profile_bloc_based.dart';
import 'package:timevictor/screens/profile_pic_view.dart';
import 'package:timevictor/widgets/image_picker_widget.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Data>(context).user;
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: AppBarTitles.profile,
            backgroundColor: kAppBackgroundColor,
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  FontAwesomeIcons.userEdit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileBlocBased.create(context),
                    ),
                  );
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: kAppBackgroundColor,
                      gradient: LinearGradient(
                        colors: [kAppBackgroundColor, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // stops: [0.5,0.5],
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // ImagePickerWidget(),
                        // Center(
                        //   child: user.profilePicURL.isEmpty ||
                        //           user.profilePicURL == null
                        //       ? CircleAvatar(
                        //           backgroundColor: Colors.white,
                        //           radius: 50.0,
                        //           child: Icon(
                        //             Icons.person,
                        //             size: 80.0,
                        //             color: kAppBackgroundColor,
                        //           ),
                        //         )
                        //       : CircleAvatar(
                        //           backgroundImage:
                        //               NetworkImage(user.profilePicURL),
                        //           radius: 50.0,
                        //         ),
                        // ),
                        Center(
                          child: ProfilePicWidget(
                            profilePicURL: user.profilePicURL,
                            heroTag: 'profilePicTag',
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.name,
                              style: kProfileTextStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            user.email,
                            style: kProfileTextStyle,
                          ),
                        ),
//                        Center(child: FlatButton(
//                          child: Text('Edit',
//                          style: TextStyle(
//                            color: Colors.blue.shade900,
//                            fontSize: 20.0
//                          ),),
//                          onPressed: () {
//                            // Todo: have to choose pic from gallery
//                            PlatformAlertDialog(
//                              title: 'Feature is Not available',
//                              content: 'This feature is currently not implemented',
//                              defaultActionText: 'OK',
//                            ).show(context);
//                          },
//                        ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Age:',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        )),
//                      SizedBox(width: 20.0,),
                        Expanded(child: Text(user.age))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Gender:',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        )),
//                      SizedBox(width: 20.0,),
                        Expanded(child: Text(user.gender))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
