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
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class HireLawyerForm extends StatefulWidget {
  const HireLawyerForm({super.key});

  @override
  State<HireLawyerForm> createState() => _HireLawyerFormState();
}

class _HireLawyerFormState extends State<HireLawyerForm> {
  final _hireLawyerFormKey = GlobalKey<FormState>();
  late Map<String, String> userData;
  String? subject, message, lawyerId;
  var generator = PBKDF2();
  var salt = Salt.generateAsBase64String(10);

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    userData = await SessionManagement.getUserData();
    // ignore: use_build_context_synchronously
    lawyerId = ModalRoute.of(context)?.settings.arguments as String;
  }

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
                      key: _hireLawyerFormKey,
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
                                  obscureText: false,
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
    if (_hireLawyerFormKey.currentState!.validate()) {
      _hireLawyerFormKey.currentState!.save();

      try {
        final details = {
          'client_id': userData['userId'],
          'lawyer_id': lawyerId,
          'subject': subject,
          'description': message
        };
        print(details);
        final response = await Supabase.instance.client.from('lawyer_booking').upsert(details);
        print(response);
        final snackBar = SnackBar(
            content: const Text(
                'Case request has been sent to lawyer. Waiting for the approval.'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        print(error);
        final snackBar = SnackBar(
            content: const Text(
                'An error occured.'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                Navigator.pop(context);
              },
            ));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

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
