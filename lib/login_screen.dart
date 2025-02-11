import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'register_screen.dart';
import 'habit_tracker_screen.dart';

import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _savedUsernameValue = '';
  String _savedPasswordValue = '';
  String _savedEmailValue = '';

  // Default credentials
  final String defaultUsername = 'testuser';
  final String defaultPassword = 'password123';

  void _login() async {
    final username = _usernameController.text;

    await checkUserData();
    if ( _isLoginValid() ) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HabitTrackerScreen(username: username),
        ),
      );
    }
    else {
      //empty out shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      showErrorToast("Invalid credentials");
    }
  }

  @override
  void initState() {
    super.initState();
    
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    //print("##############################################");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState((){
      String name = prefs.getString("name")  ?? '';
      String username = prefs.getString("username") ?? '';
      String password = prefs.getString("password") ?? '';
      String email = prefs.getString("email") ?? '';
      String country = prefs.getString("country") ?? '';
      double age = prefs.getDouble("age") ?? 0.0;

      Map<String, String> selectedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      Map<String, String> completedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('completedHabitsMap') ?? '{}'));

      if (
          name.isNotEmpty && username.isNotEmpty && password.isNotEmpty
          && email.isNotEmpty && country.isNotEmpty && age > 0
        ) {
        _savedUsernameValue = username;
        _savedPasswordValue = password;
        _savedEmailValue = email;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HabitTrackerScreen(username: username),
          ),
        );

      }
    });


  }

  
  
  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFFFFCDD2), // Light red color
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Color(0xFF81C784), // Light green color
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

  Future<void> checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _savedUsernameValue = prefs.getString('username') ?? '';
      _savedPasswordValue = prefs.getString('password') ?? '';
      _savedEmailValue    = prefs.getString('email') ?? '';

/*      print("\n\n\n\n\n#################################################");
      print(prefs.getString('username'));
      print(prefs.getString('password'));
      print(prefs.getString('name'));
      print("#################################################\n\n\n\n\n");*/
    });
  }

  bool _isLoginValid() {
    return 
    (
      (_usernameController.text == _savedUsernameValue 
          && _passwordController.text == _savedPasswordValue )
      ||
      (_usernameController.text == _savedEmailValue 
          && _passwordController.text == _savedPasswordValue )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Habitt',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.email, color: Colors.blue.shade700),
                      hintText: 'Enter Username or Email',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                      hintText: 'Enter Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Logic for forgot password can be added here
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'or',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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