import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yourchat/consts.dart';
import 'package:yourchat/helper/showsnackbar.dart';
import 'package:yourchat/screen/chatpage.dart';
import 'package:yourchat/screen/cubits/RegisterCubit/register_cubit.dart';
import 'package:yourchat/widgets/CustmBotten.dart';
import 'package:yourchat/widgets/CustomformField.dart';

class RegisterPage extends StatelessWidget {
  String? password;

  String? email;
  static String id = 'RegisterPage';
  GlobalKey<FormState> formkey = GlobalKey();

  bool isloading = false;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isloading = true;
        } else if (state is RegisterSuccess) {
          isloading = false;

          Navigator.pushNamed(context, Chatpage.id);
        } else if (state is RegisterFailure) {
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
                            "Register",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Customformfield(
                        onChanged: (data) {
                          email = data;
                        },
                        hinttext: "Email",
                      ),
                      const SizedBox(height: 10),
                      //---------------2---------------------//
                      Customformfield(
                        onChanged: (data) {
                          password = data;
                        },
                        hinttext: "Password",
                      ),
                      const SizedBox(height: 10),
                      //---------------1----------------------//
                      Custmbotten(
                        ontap: () async {
                          if (formkey.currentState!.validate()) {
                            BlocProvider.of<RegisterCubit>(context)
                                .registerUser(
                                    email: email!, password: password!);
                          } else {}
                        },
                        //-------------------------------------------//
                        text: "Register",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "alreedy have an account ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              " Login ",
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

  Future<UserCredential> registerUser() {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
