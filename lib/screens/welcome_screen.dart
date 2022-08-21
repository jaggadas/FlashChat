import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=AnimationController( duration: Duration(seconds:1),vsync: this);
    animation=ColorTween(begin: Colors.red,end: Colors.blue).animate(controller);
    controller.forward();
    controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        controller.reverse();
      }else if(status==AnimationStatus.dismissed){
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() { });
      });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
      super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text :['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent, title: 'Log In',onPressed: (){Navigator.pushNamed(context, LoginScreen.id);},),
            RoundedButton(color: Colors.lightBlueAccent, title: 'Register',onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},)
          ],
        ),
      ),
    );
  }
}

