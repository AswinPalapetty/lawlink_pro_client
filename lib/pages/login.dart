import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/extensions.dart';
import 'package:lawlink_client/widgets/custom_text_form_field.dart';
import 'package:lawlink_client/widgets/home_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formLoginKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      child: Column(
        children: [
          const Expanded(
              flex: 3,
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
                      key: _formLoginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 4, 73, 129),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15.0),
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
                              padding: const EdgeInsets.all(15.0),
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
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: onLoginSubmit,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 37, 65),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0)),
                                    child: const Text('Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ))),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 7, 90, 159),
                                  decoration: TextDecoration.underline,
                                  fontSize: 16),
                            ),
                          )
                        ],
                      ))),
            ),
          )
        ],
      ),
    );
  }

  onLoginSubmit() async {
    if (_formLoginKey.currentState!.validate()) {
      _formLoginKey.currentState!.save();
      // final data = await supabase
      //     .from('clients')
      //     .select()
      //     .eq('email', '$email')
      //     .eq('password', '$password');
      // if (data.isEmpty) {
      //   const snackBar = SnackBar(
      //     content: Text("user doesn't exist."),
      //   );
      //   // ignore: use_build_context_synchronously
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
      // else{
      //   print(data);
      //   // ignore: use_build_context_synchronously
      //   Navigator.pushNamed(context, '/home');
      // }

      try {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: '$email',
          password: '$password',
        );
        final Session? session = res.session;
        final User? user = res.user;
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        print("Login Error ==== $e");
      }

    } else {

    }
  }
}
