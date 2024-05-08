import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/custom_stepper.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OpenCase extends StatefulWidget {
  const OpenCase({super.key});

  @override
  State<OpenCase> createState() => _OpenCaseState();
}

class _OpenCaseState extends State<OpenCase> {
  late String caseRequestId, lawyerId, fileUrl;
  late int updateId;
  late PostgrestList caseUpdates;
  late Map<String, dynamic> lawyerDetails, caseRequest;
  bool isLoading = true;
  late Razorpay _razorpay;
  late Map<String, dynamic> options;

  final Map<String, String> contentTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'tiff': 'image/tiff',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  };

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Future.delayed(Duration.zero, () {
      fetchCaseEvents();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Supabase.instance.client
        .from("case_proceedings")
        .update({'amount_paid': true})
        .eq("id", updateId)
        .then((value) {
          final snackBar = SnackBar(
              content: const Text('Payment successfull.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushNamed(context, '/view_case',
              arguments: {'request_id': caseRequestId, 'lawyer_id': lawyerId});
        })
        .catchError((error) {
          print("error ===== $error");
          final snackBar = SnackBar(
              content: const Text('Payment failed.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final snackBar = SnackBar(
        content: const Text('Payment failed.'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    await Supabase.instance.client
        .from("case_proceedings")
        .update({'amount_paid': true})
        .eq("id", updateId)
        .then((value) {
          final snackBar = SnackBar(
              content: const Text('Payment successfull.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushNamed(context, '/view_case',
              arguments: {'request_id': caseRequestId, 'lawyer_id': lawyerId});
        })
        .catchError((error) {
          print("error ===== $error");
          final snackBar = SnackBar(
              content: const Text('Payment failed.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }

  void _uploadFile(int id) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print("file === ${file.path}");

      final extension = file.path.split('/').last.split('.').last;
      final randomNumber = Random().nextInt(10000).toString();
      final fileBytes = await file.readAsBytes();
      final filePath = '/$caseRequestId/file_$randomNumber';

      await Supabase.instance.client.storage
          .from('case_files')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: contentTypes[extension],
            ),
          )
          .then((value) async {
        print("Successfully inserted the file into bucket. result == $value");

        fileUrl = Supabase.instance.client.storage
            .from('case_files')
            .getPublicUrl(filePath);
        fileUrl = Uri.parse(fileUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();

        await Supabase.instance.client
            .from('case_proceedings')
            .update({'download_file': fileUrl, 'is_file_download': true})
            .eq('id', id)
            .then((value) {
              final snackBar = SnackBar(
                  content: const Text('File uploaded successfully.'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushNamed(context, '/view_case', arguments: {
                'request_id': caseRequestId,
                'lawyer_id': lawyerId
              });
            })
            .catchError((error) {
              print("error === $error");
              final snackBar = SnackBar(
                  content: const Text('Error occured.'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
      })
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print("An error occured. Error == $error"));
      print('file url ==== $fileUrl');
    } else {
      print("file uploading failed");
    }
  }

  Future<void> fetchCaseEvents() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      lawyerId = args['lawyer_id'];
      caseRequestId = args['request_id'];
    });
    print("$lawyerId $caseRequestId");
    lawyerDetails = await Supabase.instance.client
        .from('lawyers')
        .select()
        .eq('user_id', lawyerId)
        .single();
    caseRequest = await Supabase.instance.client
        .from('lawyer_booking')
        .select()
        .eq('id', int.parse(caseRequestId))
        .single();
    caseUpdates = await Supabase.instance.client
        .from('case_proceedings')
        .select()
        .eq('request_id', int.parse(caseRequestId))
        .order('created_at');
    setState(() {
      isLoading = false;
    });
  }

  makePayment(String description, String amount, {String hours = "1"}) async {
    final doubleAmount = double.parse(amount);
    final doubleHours = double.parse(hours);
    options = {
      'key': 'rzp_test_hRuJXY7QtiyiLU',
      'amount':
          doubleAmount * 100 * doubleHours, //in the smallest currency sub-unit.
      'name': lawyerDetails['name'],
      'description': description,
      'timeout': 120, // in seconds
      'prefill': {'contact': lawyerDetails['phone']}
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      child: isLoading
          ? const CustomProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Case Proceedings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14.0, top: 8, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Case Subject: ${caseRequest['subject']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Case Description: ${caseRequest['description']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lawyer Name: ${lawyerDetails['name']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Phone No: ${lawyerDetails['phone']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/chat_page',
                                    arguments: {
                                      'lawyerId': lawyerId,
                                      'lawyerName': lawyerDetails['name']
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 37, 65)),
                              child: const Text(
                                'Chat with lawyer',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomStepper(
                    steps: caseUpdates.map((update) {
                      return StepData(
                        otherStatus: update['is_file_download'] &&
                                update['download_file'] == null
                            ? "\nThe file upload request has been initiated but has not been finalized by you."
                            : (update['is_file_download'] &&
                                    update['download_file'] != null
                                ? 'A file has been successfully uploaded.'
                                : (update['is_payment_request'] &&
                                        update['amount_paid'] == false
                                    ? '\nThe lawyer has requested payment of Rs.${update['amount']}, but it has not been completed.'
                                    : (update['is_payment_request'] &&
                                            update['amount_paid']
                                        ? "\nYou have successfully paid Rs.${update['amount']}."
                                        : (update['is_file_upload'] &&
                                                update['uploaded_file'] != null
                                            ? '\nThe lawyer has uploaded a document. You can proceed to download it.'
                                            : '')))),
                        title: update['title'] ?? '',
                        message: update['message'] ?? '',
                        buttons: [
                          if (update['uploaded_file'] != null) ...[
                            ButtonData(
                              label: 'Download',
                              icon: Icons.download,
                              onPressed: () async {
                                FileDownloader.downloadFile(
                                  url: update['uploaded_file'],
                                  onDownloadError: (errorMessage) {
                                    print("download error : $errorMessage");
                                  },
                                  onDownloadCompleted: (path) {
                                    final File file = File(path);
                                    print('file : $file');
                                    final snackBar = SnackBar(
                                        content: const Text(
                                            'The file has been successfully downloaded.'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {},
                                        ));
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                );
                              },
                            ),
                          ],
                          if (update['download_file'] == null &&
                              update['is_file_download']) ...[
                            ButtonData(
                              label: 'Upload',
                              icon: Icons.upload,
                              onPressed: () => _uploadFile(update['id']),
                            ),
                          ],
                          if (update['is_payment_request'] == true &&
                              update['amount_paid'] == false) ...[
                            ButtonData(
                              label: ' Pay',
                              icon: Icons.payments,
                              onPressed: () {
                                updateId = update['id'];
                                makePayment("Make payment", update['amount']);
                              },
                            ),
                          ]
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
