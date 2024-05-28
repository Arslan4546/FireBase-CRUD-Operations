import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_getset/components/utils.dart';
import 'package:flutter/material.dart';
import '../roundbutton.dart';


class AddFireStoreScreen extends StatefulWidget {
  const AddFireStoreScreen({super.key});

  @override
  State<AddFireStoreScreen> createState() => _AddFireStoreScreenState();
}

class _AddFireStoreScreenState extends State<AddFireStoreScreen> {

  bool loading = false;
  final postController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("Posts");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Add FireStore Post", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 100,),

              TextFormField(
                maxLines: 5,
                controller: postController,
                decoration: const InputDecoration(
                  hintText: "Whats in your mind",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 40,),

              RoundButton(
                text: "Add Post",
                loading: loading,
                onTap: (){
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  firestore.doc(id).set({
                    "title" : postController.text.toString(),
                    "id" : id,
                  }).then((value){
                    Utils().toastMessage("Post is added successfully");
                    postController.text = "";
                    setState(() {
                      loading = false;
                    });

                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}


