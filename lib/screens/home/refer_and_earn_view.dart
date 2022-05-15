import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/services/dynamic_links_services.dart';
import 'package:timevictor/utils/helper.dart';

class ReferAndEarn extends StatefulWidget {
  final String uid;

  const ReferAndEarn({this.uid});

  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  bool isLoading = false;

  void toggleLoader(status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Image(
                    image: AssetImage("assets/images/referAndEarn.png"),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer us to your friends and get rewards.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Now you just need to share the link from here, it contains your referral code. You will get Cash bonus if your friends install the app using your referral link and then successfull registration of the user.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              // fontSize: 20.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    shape: kCardShape(30),
                    elevation: 5,
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        toggleLoader(true);
                        try {
                          var uri = await DynamicLinkService()
                              .createDynamicLink(widget.uid);
                          Helper.shareLink(link: uri.toString());
                        } catch (e) {
                          print(e);
                        } finally {
                          toggleLoader(false);
                        }
                      },
                    ),
                  ),
                  // Center(
                  //   child: Card(
                  //     shape: kCardShape(50),
                  //     elevation: 5,
                  //     child: IconButton(
                  //       icon: Icon(
                  //         Icons.share,
                  //         size: 30.0,
                  //       ),
                  //       onPressed: () {
                  //         Helper.shareLink(link: uid);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
