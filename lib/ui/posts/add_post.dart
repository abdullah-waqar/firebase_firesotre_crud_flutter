import 'package:firebase_database/firebase_database.dart';
import 'package:first_project_1/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();

  bool loading = false;
  // Creating the table in database (In firebase we call it node not table) with the name of post
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  // Adding data
                  databaseRef.child(id).set({
                    'id': id,
                    'title': postController.text.toString(),
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post Added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }

  
}
