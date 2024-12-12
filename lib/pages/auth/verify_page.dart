import 'package:flutter/material.dart';
import 'package:second_evaluation/main.dart';

/// VerifyPage allows users to verify their face data.
class VerifyPage extends StatelessWidget {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Position your face in the frame and tap "Verify".',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for face verification functionality.
                // Add your face verification logic here.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Face verification functionality coming soon!')),
                );

                // After verification (or placeholder), navigate to the homepage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Redirect to HomePage
                );
              },
              icon: Icon(Icons.check_circle),
              label: Text('Verify'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
