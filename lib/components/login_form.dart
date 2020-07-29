import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_chat_app/components/large_button.dart';
import 'package:group_chat_app/constants.dart';
import 'package:group_chat_app/screens/chat_screen.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool showSpinner = false;

  /* logIn clicked */
  void logInClicked() async {
    /* push keyboard down */
    FocusScope.of(context).unfocus();
    bool isInputValid = _formKey.currentState.validate();
    if (isInputValid) {
      _formKey.currentState.save();

      setState(() {
        showSpinner = true;
      });

      try {
        AuthResult userSignin = await _auth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        if (userSignin != null) {
          Navigator.pushNamed(context, ChatScreen.routeKey);
        }
        setState(() {
          showSpinner = true;
        });
      } on PlatformException catch (err) {
        String errMessage = "Sign in failed, check your credentials!";

        if (err != null) {
          errMessage = err.message;
        }

        print(errMessage);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                /* email */
                TextFormField(
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: "Enter your email",
                    labelText: "Email",
                  ),
                  style: kTextFieldInputStyling,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    email = newValue;
                  },
                ),
                /* password */
                TextFormField(
                  obscureText: true,
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: "Enter your password",
                    labelText: "Password",
                  ),
                  style: kTextFieldInputStyling,
                  validator: (value) {
                    if (value.length < 5) {
                      return "Your password should be at least 6 characters long";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    password = newValue;
                  },
                ),
              ],
            ),
          ),
        ),
        if (!showSpinner)
          LargeButton(
            buttonColor: Color(0xffFE424D),
            buttonName: "Sign in!",
            onButtonClick: logInClicked,
          ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (showSpinner)
              CircularProgressIndicator(
                backgroundColor: Colors.pink,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              )
          ],
        )
      ],
    );
  }
}
