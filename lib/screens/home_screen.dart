import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_chat_app/components/large_button.dart';
import 'package:group_chat_app/screens/login_screen.dart';
import 'package:group_chat_app/screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeKey = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = ColorTween(begin: Color(0xffFE584D), end: Color(0xff262C31))
        .animate(controller);

    controller.forward();

    /* loop through colors repeatedly for animation */
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    animation.addListener(() {
      setState(() {});
    });
  }

/* disposing animation */
  @override
  void dispose() {
    
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: animation.value,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "appLogo",
                child: Icon(
                  Icons.forum,
                  color: Colors.pink,
                  size: 100.0,
                ),
              ),
              /* login button */
              SizedBox(
                height: 15.0,
              ),
              Text(
                "We Text",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 45.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              LargeButton(
                buttonName: "Log in",
                buttonColor: Color(0xffA56FF8),
                onButtonClick: () {
                  Navigator.pushNamed(context, LoginScreen.routeKey);
                },
              ),
              /* sign up button */
              LargeButton(
                buttonName: "Register",
                buttonColor: Colors.white,
                onButtonClick: () {
                  Navigator.pushNamed(context, RegisterScreen.routeKey);
                },
              ),
            ],
          ),
        ));
  }
}
