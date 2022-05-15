import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
import 'package:timevictor/constants.dart';

class ImagePickerWidget extends StatelessWidget {
  final File image;
  final Function getImage;
  final String priImageURL;

  const ImagePickerWidget({
    Key key,
    this.image,
    this.getImage,
    this.priImageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future<void> getImage() async {
    //   var image = (await ImagePicker().getImage(
    //       source: ImageSource.gallery, maxHeight: 200.0, maxWidth: 200.0));
    //   // setState(() {
    //   //   _image = File(image.path);
    //   // });
    // }

    return Builder(
      builder: (context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: image != null
                  ? CircleAvatar(
                      backgroundColor: kAppBackgroundColor,
                      radius: 60.0,
                      child: SizedBox(
                        width: 110.0,
                        height: 110.0,
                        child: ClipOval(
                          child:
                              //  image == null
                              //     ? Icon(Icons.person,
                              //         size: 80.0, color: Colors.white)
                              //     :
                              Image.file(
                            image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 60.0,
                      backgroundImage: priImageURL != null && priImageURL.isNotEmpty
                          ? NetworkImage(priImageURL)
                          : null,
                      backgroundColor: kAppBackgroundColor,
                      child: priImageURL != null && priImageURL.isNotEmpty
                          ? null
                          : Icon(
                              Icons.person,
                              size: 80.0,
                              color: Colors.white,
                            ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              // child: CircleAvatar(
              // backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: kAppBackgroundColor,
                ),
                onPressed: () {
                  getImage();
                },
              ),
            ),
            // )

            // Padding(
            //   padding: EdgeInsets.only(top: 50.0),
            //   child: Visibility(
            //     visible: image != null,
            //     child: FlatButton(
            //       child: Text(
            //         'Update',
            //         style: TextStyle(
            //           fontSize: 20.0,
            //           color: kAppBackgroundColor,
            //         ),
            //       ),
            //       onPressed: () {},
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
