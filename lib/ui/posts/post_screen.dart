import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_project_1/ui/auth/login_screen.dart';
import 'package:first_project_1/ui/posts/add_post.dart';
import 'package:first_project_1/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // There are two medhod to fetch the data from firebase
  // 1 --> FirebaseAnimatedList
  // 2 --> StreamBuilder
  final auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref("Post");

  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // To Remove back button
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Post"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                defaultChild: const Text("Loading"),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: ((context) => [
                              PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(title,
                                        snapshot.child('id').value.toString());
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text("Edit"),
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  onTap: () {
                                    
                                    ref
                                        .child(snapshot
                                            .child('id')
                                            .value
                                            .toString())
                                        .remove();
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  )),
                            ]),
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return AddPostScreen();
          })));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(hintText: "Edit here"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': editController.text.toLowerCase(),
                    }).then((value) {
                      Utils().toastMessage("Post Updated");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }
}



// Fetching data with the help of Stream builder

          // Expanded(
          //     child: StreamBuilder(
          //         stream: ref.onValue,
          //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //           if (!snapshot.hasData) {
          //             return const CircularProgressIndicator();
          //           } else {
          //             Map<dynamic, dynamic> map =
          //                 snapshot.data!.snapshot.value as dynamic;

          //             List<dynamic> list = [];

          //             list.clear();

          //             list = map.values.toList();

          //             return ListView.builder(
          //                 itemCount: snapshot.data!.snapshot.children.length,
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                     title: Text(list[index]['title']),
          //                     subtitle: Text(list[index]['id'].toString()),
          //                   );
          //                 });
          //           }
          //         })),
