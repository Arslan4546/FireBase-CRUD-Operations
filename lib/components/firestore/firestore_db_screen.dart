import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_getset/components/utils.dart';
import 'package:flutter/material.dart';

import 'add_firestore_data.dart';


class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection("Posts").snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Fire Store Screen", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding:const  EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }

                if(snapshot.hasError){
                  return const Text("Some Error");
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]["title"].toString()),
                        subtitle: Text(snapshot.data!.docs[index]["id"].toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  showMyDialog(snapshot.data!.docs[index]["title"].toString(), snapshot.data!.docs[index]["id"].toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: (){
                                  ref.doc(snapshot.data!.docs[index]["id"].toString()).delete();
                                  Navigator.pop(context);
                                },
                                leading: Icon(Icons.delete),
                                title: Text("Delete"),
                              ),
                            ),
                          ],),
                      );
                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFireStoreScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async{
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: const Border(),
          title: const Text("Update Post"),

          content: TextFormField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: "Update Your Text",
            ),
          ),

          actions: [
            TextButton(
              onPressed: (){ Navigator.pop(context); },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: (){
                ref.doc(id).update({
                  "title" : editController.text.toString(),
                }).then((value){
                  Utils().toastMessage("Post Updated Successfully");
                  Navigator.pop(context);
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                  Navigator.pop(context);
                });
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}


