import 'package:bon_voyage/main.dart';
import 'package:bon_voyage/screens/asl_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  static const String id = 'camera_screen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isWorking = false;
  String result = "", sentence = "";
  late CameraController cameraController;
  late CameraImage? imgCamera;

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.veryHigh);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cameraController.startImageStream((imagesFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imagesFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    });
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      result = "";
      recognitions!.forEach((response) {
        result += response["label"];
      });

      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Widget _displayCameraFeed() {
    try {
      return CameraPreview(cameraController);
    } catch (e) {
      return Center(
        child: Text(
          "Loading",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignPrism"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ASLScreen.id);
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: _displayCameraFeed(),
              ),
            ),
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                        "Sentence: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                          child: Text(sentence, style: TextStyle(fontSize: 18)))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Prediction: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(result, style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sentence += result;
                      });
                    },
                    child: Text('Append', style: TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sentence += " ";
                      });
                    },
                    child: Text(
                      'Space',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (sentence.length > 0) {
                          sentence = sentence.substring(0, sentence.length - 1);
                        }
                      });
                    },
                    child: Text(
                      'BackSpace',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
