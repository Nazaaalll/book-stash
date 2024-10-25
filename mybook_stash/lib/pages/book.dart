
import 'package:book_stash/service/database.dart';
import 'package:book_stash/utlis/toast.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {

TextEditingController titleController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController authorController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a book'),),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20,top: 30,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title' ,style: TextStyle(color: Colors.black,fontSize: 20),),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  
                ),
              ),
              const Text('price' ,style: TextStyle(color: Colors.black,fontSize: 20),),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: priceController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  
                ),
              ),
              const Text('auther' ,style: TextStyle(color: Colors.black,fontSize: 20),),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: authorController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: OutlinedButton(child: const Text('add'),
                onPressed: ()async {
                  String id = randomAlphaNumeric(10);
                  Map<String,dynamic>bookInfoMap ={
                    'Title ': titleController.text,
                    'price': priceController.text,
                    'auther': authorController.text ,
                    "id" : id,
                  };
                  await DatabasHelper().addDookDetails(bookInfoMap, id).then((value){
                  Message.show(message: 'Book has been added!');
                  Navigator.of(context).pop();
                  });
                  
                },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}