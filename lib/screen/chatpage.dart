import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourchat/consts.dart';
import 'package:yourchat/models/message.dart';
import 'package:yourchat/screen/cubits/Chatcubit/chat_cubit.dart';
import 'package:yourchat/widgets/chatbuble.dart';
import 'package:firebase_core/firebase_core.dart';

class Chatpage extends StatelessWidget {
  List<Message> messagelist = [];

  Chatpage({
    super.key,
  });
  final ScrollController _controller = ScrollController();
  static String id = 'chatpage';
  bool isloading = false;
  TextEditingController mycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 212, 212),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: KprimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Klogo,
              height: 40,
              width: 40,
            ),
            Text(
              " Chat ",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 3,
          ),
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messagelist = state.messages;
                }
              },
              builder: (context, state) {
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagelist.length,
                    itemBuilder: (context, index) {
                      return messagelist[index].idd == email
                          ? Chatbuble(
                              message: messagelist[index],
                            )
                          : Chatbubleforfriends(message: messagelist[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: mycontroller,
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendmessage(message: data, email: email);
                mycontroller.clear();
                _controller.animateTo(
                  0,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 500),
                );
              },
              decoration: InputDecoration(
                  hintText: "Send Message...",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: KprimaryColor,
                    ),
                    onPressed: () {
                      if (mycontroller.text.trim().isNotEmpty) {
                        FirebaseFirestore.instance.collection('messages').add({
                          kmessage: mycontroller.text.trim(),
                          kcreatAt: Timestamp.now(),
                          KId: FirebaseAuth.instance.currentUser!
                              .email, // استخدم البريد الحقيقي للمُرسل
                        });
                      }
                      mycontroller.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: KprimaryColor),
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
