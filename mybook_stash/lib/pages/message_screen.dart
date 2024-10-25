import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Map payloadContent ={};



  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context)!.settings.arguments;
    
// background terminate state

    if(data is RemoteMessage)
    {
      payloadContent = data.data;
    }
    //foreground data
    if(data is NotificationResponse){
      //decode to json
      payloadContent = jsonDecode(data.payload!);

    }

    String firstKey = payloadContent.keys.first;


    return Scaffold(
      appBar: AppBar(title:  const Text('Message'),),
      body: Center(child: Padding(padding: const EdgeInsets.all(8),child: Column(
        children: [
          const SizedBox(height: 10,),
          SizedBox(width: double.infinity,
          height: 100,
          child: Card(
            color: Colors.purple,
            elevation: 10,
            child: Padding(padding: const EdgeInsets.all(8.0),
            child: Text("Book Name: :$firstKey",style: const TextStyle(fontSize: 21,color: Colors.white),),
            ),
          ),
          ),
          const SizedBox(height: 10,),
          SizedBox(width: double.infinity,
          height: 100,
          child: Card(
            color: Colors.purple,
            elevation: 10,
            child: Padding(padding: const EdgeInsets.all(8.0),
            child: Text("Price: :${payloadContent[firstKey]}",style: const TextStyle(fontSize: 21,color: Colors.white),),
            ),
          ),
          ),
        ],
      ),),),
    );
  }
}