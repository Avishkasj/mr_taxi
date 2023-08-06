import 'package:flutter/material.dart';
import 'package:mr_taxi/Register.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image(
                    image: AssetImage(
                      'assets/logo-with out bg.png',
                    ),
                    height: 250,
                    width: 400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                "Select Your Vehicle",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Lets's book your vehicle first you neetto register to the system Thnak you",
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2.0, // set the border weight to 2.0
                              color: Colors.black,
                            ),
                            fixedSize: Size(150, 50),
                          ),
                          onPressed: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => login()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2.0, // set the border weight to 2.0
                              color: Colors.black,
                            ),
                            fixedSize: Size(150, 50),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Register()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
