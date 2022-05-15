import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/screens/downloadModel.dart';
import 'package:timevictor/utils/helper.dart';

class UpdateAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle = TextStyle(
      color: Colors.black54,
      fontSize: 15.0,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [kAppBackgroundColor, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.5, 0.5]),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  child: ListView(
                    children: [
                      Image(
                        height: 120.0,
                        width: 120.0,
                        image: AssetImage('assets/images/tvLogoFinal.png'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text(
                          'Time To Update !',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      // Text(
                      //   'We have grown!!',
                      //   textAlign: TextAlign.center,
                      //   style: fontStyle,
                      // ),
                      Text(
                        'There is an update available.',
                        textAlign: TextAlign.center,
                        style: fontStyle,
                      ),
                      Text(
                        ' Please update your app.',
                        textAlign: TextAlign.center,
                        style: fontStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 80.0, vertical: 30.0),
                      //   child: FlatButton(
                      //     shape: kButtonShape,
                      //     color: Colors.green,
                      //     // shape: kButtonShape,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Icon(
                      //           Icons.save_alt,
                      //           size: 30.0,
                      //           color: Colors.white,
                      //         ),
                      //         SizedBox(
                      //           width: 10.0,
                      //         ),
                      //         Text(
                      //           'Update Now',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 18.0,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     onPressed: () {
                      //       // build(context);
                      //       // Helper.openLink(context, kAppUpdateUrl);
                      //     },
                      //   ),
                      // ),
                      ViewModelProvider<DownloadModel>.withConsumer(
                        viewModelBuilder: () => DownloadModel(),
                        builder: (context, model, child) => Stack(
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Visibility(
                                  visible: true,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10.0,
                                    value: model.downloadProgress,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: FlatButton(
                                  shape: kButtonShape,
                                  color: Colors.green,
                                  // shape: kButtonShape,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.save_alt,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Update Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    // await model.startDownloading();
                                    // build(context);
                                    // Helper.openLink(context, kAppUpdateUrl);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
