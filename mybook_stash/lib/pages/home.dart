
import 'dart:core';

import 'package:book_stash/pages/book.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/database.dart';
import 'package:book_stash/utlis/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController authorController = TextEditingController();
  Stream? bookStream;
  dynamic getInfoInit( )async{
    bookStream = await DatabasHelper().getAllBooksInfo();
    setState(() {
      
    });
  }
  @override
  void initState() {
    getInfoInit();
    super.initState();
    
  }
  

  Widget getAllBooksInfo(){
    return StreamBuilder( builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index){
          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
          return  Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.book_rounded,size: 45,color: Colors.deepPurpleAccent,),
                          InkWell(
                            onTap: () {
                              titleController.text =  documentSnapshot["Title"];
                              priceController.text = documentSnapshot["Price"];
                              authorController.text = documentSnapshot["auther"];

                              editBook(documentSnapshot["id"]);
                              
                            },
                            child: const Icon(Icons.edit_document,size: 45,
                            color: Color.fromARGB(255, 195, 192, 243),)),
                            InkWell(
                              onTap: () {
                                showDeleteConfirmDialogue(context, documentSnapshot["id"]);
                                
                              },
                              child: const Icon(Icons.delete_forever,size: 45,color: Colors.greenAccent,)),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text('Title : ${documentSnapshot["Title"]}', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      Text('price : ${documentSnapshot["Price"]}', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      Text('Auther :${documentSnapshot["Auther"]} ', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
          );

        }) : Container();
    },stream: bookStream,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  const Text('Book Stash'),
      actions: [
        IconButton(onPressed: ()async{
          await AuthServiceHelper.logout();
          Navigator.pushReplacementNamed(context, "/login");

        }, icon: const Icon(Icons.logout_rounded))
      ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10,right: 20, top: 25),
        child: Column(
          children: [
            Expanded(child: getAllBooksInfo())
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: 
        (context) =>const Books()));

      },
      child:const Icon(Icons.add) ,
      ),
    );
  }
Future editBook(String id){
  return showDialog(context: context , builder: (context) => AlertDialog(
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Edit a book", style: TextStyle(color: Colors.deepPurple,fontSize: 20,fontWeight: FontWeight.bold),),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.cancel_outlined,size: 35,color: Colors.deepPurple,))
            ],
          ),
          const Divider(height: 10,color: Colors.deepPurple,thickness: 5,),
          const SizedBox(height: 10,),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  OutlinedButton(onPressed: ()async{
      
                  Map<String, dynamic> updateDetails = {
                    "Title" : titleController,
                    'price': priceController.text,
                      'auther': authorController.text ,
                      "id" : id,
                    
                      
                    };
                    await DatabasHelper().updateBook(id, updateDetails).then((value){
                      Message.show(message: "succesfully updated");
                      Navigator.pop(context);
      
                    });
      
                  }, child: const Text('update')),
      
                  OutlinedButton(onPressed: (){
                   Navigator.pop(context);
                  }, child: const Text('cancel'))
                ],)
      
        ],
      ),
    ),
  ));
}

void showDeleteConfirmDialogue(BuildContext content,String id){
  showDialog(context: context,
   builder: (BuildContext context){
    return AlertDialog(
      title: const Text('Confirm deletion'),
      content: const Text('Are you sure you want to delete this book?'),
      actions: [
        TextButton(onPressed: ()async{
          await DatabasHelper().deletBook(id);
          Navigator.pop(context);

        }, child: const Text('Yes')),
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);

        }, child: const Text('No')),
      ],
    );
   });
}


}
