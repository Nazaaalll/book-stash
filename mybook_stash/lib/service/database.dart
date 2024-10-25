import 'package:cloud_firestore/cloud_firestore.dart';


class DatabasHelper{

Future addDookDetails(Map<String,dynamic> bookInfoMap,String id)async
{
  return await FirebaseFirestore.instance.collection("Book").doc(id).set(bookInfoMap);
}

//get all books info
Future<Stream<QuerySnapshot>> getAllBooksInfo() async{
  return FirebaseFirestore.instance.collection("Book").snapshots();
}
//update operation
Future updateBook(String id,Map<String, dynamic>updateDetails)async{
  return await FirebaseFirestore.instance.collection("Book").doc(id).update(updateDetails);

}
Future deletBook(String id) async{
  return await FirebaseFirestore.instance.collection("Book").doc(id).delete();
}
}
