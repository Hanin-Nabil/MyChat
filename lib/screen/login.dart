import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yourchat/consts.dart';
import 'package:yourchat/helper/showsnackbar.dart';
import 'package:yourchat/screen/Register.dart';
import 'package:yourchat/screen/chatpage.dart';
import 'package:yourchat/screen/cubits/Chatcubit/chat_cubit.dart';
import 'package:yourchat/screen/cubits/logincubit/login_cubit.dart';
import 'package:yourchat/widgets/CustmBotten.dart';
import 'package:yourchat/widgets/CustomformField.dart';

class LoginPage extends StatelessWidget {
  String? email, password;

  TextEditingController mycontroller = TextEditingController();

  static String id = 'LoginPage';

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isloading = true;
        } else if (state is LoginSuccess) {
          isloading = false;
          BlocProvider.of<ChatCubit>(context).getmessage();
          Navigator.pushNamed(context, Chatpage.id);
        } else if (state is LoginFailure) {
          isloading = false;

          showSnackbar(context, state.errormessage);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Scaffold(
          backgroundColor: KprimaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        Klogo,
                        height: 120,
                        width: 100,
                      ),
                      Text(
                        "Scholar Chat ",
                        style: TextStyle(
                            fontSize: 24,
                            color: kSecoundPrimaryColor,
                            fontFamily: "Pacifico"),
                      ),
                      const Row(
                        children: [
                          Text(
                            "Login ",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ],
                      ),
                      Customformfield(
                        onChanged: (data) {
                          email = data;
                          mycontroller.clear();
                        },
                        hinttext: "Email",
                      ),
                      const SizedBox(height: 10),
                      Customformfield(
                        onChanged: (data) {
                          password = data;
                          mycontroller.clear();
                        },
                        hinttext: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      //_____________________________________________________________//
                      Custmbotten(
                        ontap: () async {
                          if (formkey.currentState!.validate()) {
                            BlocProvider.of<LoginCubit>(context)
                                .SinginUser(email: email!, password: password!);
                          } else {}
                        },
                        text: "Login",
                      ),
                      //___________________________________________________________________________//
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "dont have an account ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RegisterPage.id);
                            },
                            child: Text(
                              "  Register ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kSecoundPrimaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> SinginUser() {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
