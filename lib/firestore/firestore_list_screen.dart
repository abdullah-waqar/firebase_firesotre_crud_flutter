import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_project_1/firestore/add_firestore_data.dart';
import 'package:first_project_1/ui/auth/login_screen.dart';
import 'package:first_project_1/ui/posts/add_post.dart';
import 'package:first_project_1/utils/utils.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;

  final editController = TextEditingController();

  // This one is using to fetch the data from firestore because it is giving us the snapshot
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();

  // We are getting the Collection referecnce to update and delete the data from firestore

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // To Remove back button
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Firestore"),
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
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            ref
                                .doc(
                                    snapshot.data!.docs[index]['id'].toString())
                                .update({
                              'title': 'This value has been updated'
                            }).then((value) {
                              Utils().toastMessage("Updated");
                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete();
                            },
                          ),
                        );
                      }));
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return AddFirestoreDataScreen();
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
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }
}
