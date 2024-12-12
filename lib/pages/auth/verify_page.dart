import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:second_evaluation/main.dart';
import 'dart:io';
import 'dart:convert'; // For base64 encoding

/// VerifyPage allows users to verify their face data.
class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  XFile? _capturedImage; // To store the captured image
  String? _imageBlobData; // To store the base64 encoded blob data

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  void _initializeCamera() async {
    // Fetch the available cameras
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);

    // Initialize the controller and handle errors
    _initializeControllerFuture = _cameraController.initialize();

    // Set the state to indicate that the camera has been initialized
    _initializeControllerFuture.then((_) {
      setState(() {
        _isCameraInitialized = true;
      });
    }).catchError((e) {
      // Handle any errors during camera initialization
      print('Error initializing camera: $e');
    });
  }

  // Capture image and convert to blob data (base64 encoding)
  void _captureImage() async {
    try {
      XFile image = await _cameraController.takePicture();
      setState(() {
        _capturedImage = image; // Store the captured image
      });

      // Convert the captured image to bytes and then to base64
      File imageFile = File(image.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Store the base64 encoded image blob data
      setState(() {
        _imageBlobData = base64Image;
      });
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Face'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: _isCameraInitialized
                    ? FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return _capturedImage == null
                                ? CameraPreview(_cameraController)
                                : Image.file(File(_capturedImage!.path)); // Show captured image
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    : CircularProgressIndicator(),
              ),
            ),
            // Capture button (visible only if no image is captured)
            if (_capturedImage == null)
              ElevatedButton.icon(
                onPressed: _captureImage,
                icon: Icon(Icons.camera_alt),
                label: Text('Capture'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            SizedBox(height: 16),
            // If image is captured, show confirmation buttons
            if (_capturedImage != null) ...[
              Text(
                'Do you confirm this image?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to home page on confirmation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                icon: Icon(Icons.check_circle),
                label: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _capturedImage = null; // Reset the captured image
                  });
                },
                child: Text(
                  'Retake',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
            // Cancel button
            if (_capturedImage == null) ...[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
            // Display the blob data (base64 encoded image)
            if (_imageBlobData != null) ...[
              SizedBox(height: 20),
              Text(
                'Blob Data (Base64 Encoded):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _imageBlobData!,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
