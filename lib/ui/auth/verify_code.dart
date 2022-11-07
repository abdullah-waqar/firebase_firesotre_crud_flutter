import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_1/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;

  final auth = FirebaseAuth.instance;

  final verifyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: verifyCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '6 digit code'),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                title: 'Verify',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());

                  try {
                    await auth.signInWithCredential(credential);
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                },
                loading: loading,
              )
            ],
          ),
        ));
  }
}
