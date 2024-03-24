// import 'package:flutter/material.dart';

// class HireLawyerForm extends StatefulWidget {
//   const HireLawyerForm({super.key});

//   @override
//   State<HireLawyerForm> createState() => _HireLawyerFormState();
// }

// class _HireLawyerFormState extends State<HireLawyerForm> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class HireLawyerForm extends StatefulWidget {
  const HireLawyerForm({super.key});

  @override
  State<HireLawyerForm> createState() => _HireLawyerFormState();
}

class _HireLawyerFormState extends State<HireLawyerForm> {
  final _formSignUpKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? subject, message;
  final supabase = Supabase.instance.client;
  var generator = PBKDF2();
  var salt = Salt.generateAsBase64String(10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const Expanded(
                flex: 0,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
              flex: 8,
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
                            "Connect with Lawyer",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomTextFormField(
                                  autofillHints: null,
                                  obscureText: true,
                                  hintText: 'Subject',
                                  labelText: 'Subject',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      subject = value;
                                    });
                                  })),

                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              minLines: 4,
                              maxLines: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is required.";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      'Give a detailed explanation about the matter.',
                                  labelText: 'Message',
                                  alignLabelWithHint: true),
                              onSaved: (value) {
                                setState(() {
                                  message = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: onFormSubmit,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 37, 65),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0)),
                                    child: const Text('Connect',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ))),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  onFormSubmit() async {
    if (_formSignUpKey.currentState!.validate()) {
      _formSignUpKey.currentState!.save();

      // try {
      //   final AuthResponse res =
      //       await supabase.auth.signUp(email: '$email', password: '$password');

      //   try {
      //     final userDetails = {
      //       'user_id': res.user!.id,
      //       'name': '$firstName $lastName',
      //       'phone': phone
      //     };

      //     final resp = await supabase.from('clients').upsert(userDetails);

      //     print('Insertion successful: $resp');

      //     // ignore: use_build_context_synchronously
      //     Navigator.pushNamed(context, '/home');
      //   } catch (e) {
      //     print('insertion error =======  $e');
      //   }
      // } catch (e) {
      //   print('auth error =======  $e');
      //   final snackBar = SnackBar(
      //       content: const Text('email already exists.'),
      //       action: SnackBarAction(
      //         label: 'Close',
      //         onPressed: () {
      //           emailController.clear();
      //         },
      //       ));
      //   // ignore: use_build_context_synchronously
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
      // } else {
      //   final snackBar = SnackBar(
      //       content: const Text('email already exists.'),
      //       action: SnackBarAction(
      //         label: 'Close',
      //         onPressed: () {
      //           emailController.clear();
      //         },
      //       ));
      //   // ignore: use_build_context_synchronously
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    } else {}
  }

}
