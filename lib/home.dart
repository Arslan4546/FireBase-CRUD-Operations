


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'add_post.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Home Screen", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding:const  EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(child: Text("Loading...")),
                itemBuilder: (context, snapshot, animation,  index){
                  return ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


