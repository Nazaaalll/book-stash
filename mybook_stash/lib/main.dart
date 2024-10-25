import 'dart:convert';

import 'package:book_stash/auth/ui/login_screen.dart';
import 'package:book_stash/auth/ui/signup_screen.dart';
import 'package:book_stash/firebase_options.dart';
import 'package:book_stash/pages/home.dart';
import 'package:book_stash/pages/message_screen.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _fireBackgroundMesssage(RemoteMessage message)async{
  if(message.notification!=null){
    print('A notification found in background');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //initialize firebase messaging
  await pushNotificationHelper.init();
  //initialize local notification
  await pushNotificationHelper.localNotificationInitialization();
  FirebaseMessaging.onBackgroundMessage(_fireBackgroundMesssage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    if(message.notification!=null){
      print("Background notification tapped!");
      navigatorKey.currentState!.pushNamed("/message",arguments: message);
    }
  });
  //foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    String payloadContent = jsonEncode(message.data);
    print("message found in background");
    if(message.notification!=null){
      pushNotificationHelper.showLocalNotification(title: message.notification!.title!, 
      body: message.notification!.body!, payload: payloadContent,);
    }
  });

  // for handling terminated state
  final RemoteMessage? message = 
  await FirebaseMessaging.instance.getInitialMessage();
  if(message!=null){
    print("Frome terminated state");
    Future.delayed(const Duration(seconds: 3),(){
      navigatorKey.currentState!.pushNamed("/message",arguments: message);

    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      //home: LoginScreen(),
      routes: {
        "/" : (context) => const checkUserBookStash(),
        "/login" : (context) => const LoginScreen(),
        "/home" :(context) => const Home(),
        "/SignUp" : (context) => const signUpScreen(),
        "/message" : (context) => const MessageScreen(),
      },  
    );
  }
}
class checkUserBookStash extends StatefulWidget {
  const checkUserBookStash({super.key});

  @override
  State<checkUserBookStash> createState() => _checkUserBookStashState();
}

class _checkUserBookStashState extends State<checkUserBookStash> {

  @override
  void initState() {
    AuthServiceHelper.isUserLoggedIn().then((value){
      if(value){
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pushReplacementNamed(context, "/login");

      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
}

}

