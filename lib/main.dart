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
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/chatbot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_URL']}',
    anonKey: '${dotenv.env['SUPABASE_ANONKEY']}',
  );

  String initialRoute;
  final data = await SessionManagement.getUserData();
  if(data['name'] != ''){
    initialRoute = '/';
  }
  else{
    initialRoute = '/home';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key,required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawLink Pro',
      theme: ThemeData(
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

      initialRoute: initialRoute,
    );
  }
}

