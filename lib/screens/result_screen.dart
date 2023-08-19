import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  static const routeName = '/result-screen';
  final storage = FirebaseStorage.instance;

  //String? imgUrl;

  @override
  Widget build(BuildContext context) {
    Future<String> getImage() async {
      var imgName = (ModalRoute.of(context)?.settings.arguments as String);
      imgName.replaceAll('>', '');
      imgName.replaceAll(':', '');
      imgName.replaceAll('/', '');
      imgName.replaceAll('\\', '');
      imgName += '.jpg';
      final ref = storage.ref().child(imgName);
      //Screenshot_20230725-173154_Drive.jpg

      final url = await ref.getDownloadURL();

      print(url);
      return url;

      // setState(() {
      //   imgUrl = url;
      //   print(imgUrl);
      // });
    }

    final deviceSize = MediaQuery.of(context).size;
    //String imgName = ModalRoute.of(context)?.settings.arguments as String;
    //print(imgName);

    //getImage();
    //print(imgUrl);

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.black,
            title: const Text(
              'QR Code Result',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
            )),
        body: FutureBuilder(
            future: getImage(),
            //Future.delayed(Duration(seconds: 2)),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      snapshot.data != null
                          ? Container(
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    'assets/images/Loading_icon.gif'),
                                image: NetworkImage(
                                  snapshot.data!,
                                ),
                                fit: BoxFit.contain,
                                height: deviceSize.height * 0.6,
                              ),
                            )
                          : Container(
                              height: deviceSize.height * 0.6,
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                'No Exam Pass found for that QRCode. May be a fake one!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 35),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .popUntil(ModalRoute.withName('/')),
                        child: const Text(
                          'New Scan',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ));
            }));
  }
}
