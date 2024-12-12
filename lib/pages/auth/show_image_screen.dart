import 'package:flutter/material.dart';
import 'dart:convert'; // For base64 decoding
import './encryption.dart'; // Import the RSAEncryption class

/// ShowImageScreen displays the captured image and its encrypted blob data.
class ShowImageScreen extends StatelessWidget {
  final String imageBlobData;

  // Constructor to pass the image blob data to this screen
  ShowImageScreen({required this.imageBlobData});

  @override
  Widget build(BuildContext context) {
    // Instantiate the RSAEncryption class to encrypt the blob data
    RSAEncryption rsaEncryption = RSAEncryption();

    // Encrypt the image blob data
    String encryptedBlobData = rsaEncryption.encryptText(imageBlobData.substring(0, 20));

    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap content in SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Captured Image:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Resize the image and fit it well within the available space
              Center(
                child: Image.memory(
                  base64Decode(imageBlobData),
                  height: 250, // Set height of the image to make it smaller
                  width: double.infinity, // Make it fit the available width
                  fit: BoxFit.contain, // Adjust the image aspect ratio within the available space
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Encrypted Blob Data (Base64 Encoded):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Display the first 20 characters of the encrypted blob data
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  encryptedBlobData, // Show only first 20 characters
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Full Blob Data:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Display the full encrypted blob data
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  imageBlobData, // Show full encrypted blob data
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
