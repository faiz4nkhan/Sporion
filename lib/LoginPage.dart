import 'package:flutter/material.dart';
import 'package:livebuzz/UpdatePage.dart'; // Ensure this import is correct

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Login handler function
    void handleLogin() {
      // Check for username and password
      if (usernameController.text == "admin" && passwordController.text == "admin") {
        // Navigate to the BasketballPage if credentials are correct
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePage(isLoggedIn: true,), // Pass isLoggedIn if needed
          ),
        );
      } else {
        // Show error message if credentials are wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleLogin();  // Call the handleLogin method to validate credentials
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
