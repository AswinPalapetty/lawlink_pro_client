import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/extensions.dart';
import 'package:lawlink_client/widgets/custom_text_form_field.dart';
import 'package:lawlink_client/widgets/home_scaffold.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formSignUpKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  String? firstName, lastName, email, password, cpassword;

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: Column(
      children: [
        const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            )),
        Expanded(
          flex: 7,
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 73, 129)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  hintText: 'Enter First Name',
                                  labelText: 'First Name',
                                  validator: (value) =>
                                      firstNameValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  },
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  hintText: 'Enter Last Name',
                                  labelText: 'Last Name',
                                  validator: (value) =>
                                      lastNameValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  },
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: const [AutofillHints.email],
                            obscureText: false,
                            hintText: 'Enter Email ID',
                            labelText: 'Email',
                            validator: (value) {
                              if (!value!.isValidEmail) {
                                return "Enter a valid Email.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: true,
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            validator: (value) {
                              if (!value!.isValidPassword) {
                                return "Enter a valid Password.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            controller: passwordController,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: true,
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (!value!.isValidPassword) {
                                return "Enter a valid Password.";
                              } else if (value != passwordController.text) {
                                return "Password doesn't match.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                cpassword = value;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onSignupSubmit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 3, 37, 65),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0)),
                                child: const Text('Signup',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ))),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 90, 159),
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  onSignupSubmit() {
    if (_formSignUpKey.currentState!.validate()) {
      _formSignUpKey.currentState!.save();
      print('$email $password $cpassword');
    } else {}
  }

  firstNameValidator(value) {
    if (value == '') {
      return "Enter First Name.";
    }
    return null;
  }

  lastNameValidator(value) {
    if (value == '') {
      return "Enter Last Name.";
    }
    return null;
  }
}
