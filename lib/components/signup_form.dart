import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_chat_app/components/large_button.dart';
import 'package:group_chat_app/constants.dart';
import 'package:group_chat_app/screens/chat_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String name;
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  /* logIn clicked */
  void signUpClicked() async {
    /* push keyboard down */
    FocusScope.of(context).unfocus();
    bool isInputValid = _formKey.currentState.validate();
    if (isInputValid) {
      _formKey.currentState.save();

      /* start firebase registering */
      setState(() {
        showSpinner = true;
      });

      try {
        final newUser = await _auth
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password.trim())
            .then((value) async {
          UserUpdateInfo userInfo = UserUpdateInfo();
          userInfo.displayName = name.trim();
          await value.user.updateProfile(userInfo);
          await value.user.reload();
        });

        /* nagivate to chat page */
        Navigator.pushNamed(context, ChatScreen.routeKey);

        /* kill the spinner */
        setState(() {
          showSpinner = false;
        });
      } on PlatformException catch (err) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            err.message,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red,
        ));
      } catch (err) {
        print(err);
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
                /* name */
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: "Enter your profile name",
                    labelText: "Name",
                  ),
                  style: kTextFieldInputStyling,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    name = newValue;
                  },
                ),
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
            buttonName: "Sign up!",
            onButtonClick: signUpClicked,
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
