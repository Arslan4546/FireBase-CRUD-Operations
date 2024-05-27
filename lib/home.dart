


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'add_post.dart';
import 'components/utils.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref("Post");

  final searchController = TextEditingController();
  final editController = TextEditingController();

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

            // Expanded(
            //   child: StreamBuilder(
            //     stream: ref.onValue,
            //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
            //       if(!snapshot.hasData){
            //         return const CircularProgressIndicator();
            //       }else{
            //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
            //
            //         List<dynamic> list = [];
            //         list.clear();
            //         list = map.values.toList();
            //
            //         return ListView.builder(
            //           itemCount: snapshot.data!.snapshot.children.length,
            //           itemBuilder: (context, index){
            //             return ListTile(
            //               title: Text(list[index]['title']),
            //               subtitle: Text(list[index]['id']),
            //             );
            //           },
            //         );
            //       }
            //     }
            //   ),
            // ),
            // const Divider(),

            const SizedBox(height: 30.0,),

            TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
            const SizedBox(height: 30.0,),


            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(child: Text("Loading...")),
                itemBuilder: (context, snapshot, animation,  index){

                  String title = snapshot.child("title").value.toString();
                  String id = snapshot.child("id").value.toString();

                  if(searchController.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child("title").value.toString()),
                      subtitle: Text(snapshot.child("id").value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title, id);
                              },
                              title: const Text("Edit"),
                              leading: const Icon(Icons.edit),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              onTap: (){
                                ref.child(id).remove();
                                Navigator.pop(context);
                              },
                              title: const Text("Delete"),
                              leading: const Icon(Icons.delete),
                            ),
                          )
                        ],),
                    );
                  }else if(title.toLowerCase().contains(searchController.text.toLowerCase().toString())){
                    return ListTile(
                      title: Text(snapshot.child("title").value.toString()),
                      subtitle: Text(snapshot.child("id").value.toString()),
                    );
                  }else{
                    return Container();
                  }


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
                ref.child(id).update({
                  "title": editController.text.toString(),
                }).then((value){
                  Utils().toastMessage("Post updated Successfully");
                  Navigator.pop(context);
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
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


