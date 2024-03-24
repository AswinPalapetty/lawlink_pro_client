import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lawlink_client/pages/client_home.dart';
import 'package:lawlink_client/pages/hire_lawyer_form.dart';
import 'package:lawlink_client/pages/lawyers.dart';
import 'package:lawlink_client/pages/main_home.dart';
import 'package:lawlink_client/pages/login.dart';
import 'package:lawlink_client/pages/signup.dart';
import 'package:lawlink_client/pages/user_reviews.dart';
import 'package:lawlink_client/pages/view_lawyer.dart';
import 'package:lawlink_client/pages/write_review.dart';
import 'package:lawlink_client/widgets/chatbot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_URL']}',
    anonKey: '${dotenv.env['SUPABASE_ANONKEY']}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawLink Pro',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

      routes: {
        '/':(context) => const Home(),
        '/login':(context) => const Login(),
        '/signup':(context) => const Signup(),
        '/home':(context) => const ClientHome(),
        '/chatbot':(context) => const ChatBot(),
        '/lawyers':(context) => const Lawyers(),
        '/view_lawyer':(context) => const ViewLawyer(),
        '/user_reviews':(context) => const UserReviews(),
        '/write_review':(context) => const WriteReview(),
        '/hire_lawyer':(context) => const HireLawyerForm()
      },

      initialRoute: '/',
    );
  }
}

