import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_1/ui/auth/verify_code.dart';
import 'package:first_project_1/utils/utils.dart';
import 'package:first_project_1/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;

  final auth = FirebaseAuth.instance;

  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '+92 235 535 908'),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: ((error) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      }),
                      codeSent: (verificationId, forceResendingToken) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils().toastMessage(e.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                }),
          ],
        ),
      ),
    );
  }
}
