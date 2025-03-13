//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourchat/firebase_options.dart';
import 'package:yourchat/screen/Register.dart';
import 'package:yourchat/screen/chatpage.dart';
import 'package:yourchat/screen/cubits/Chatcubit/chat_cubit.dart';
import 'package:yourchat/screen/cubits/RegisterCubit/register_cubit.dart';
import 'package:yourchat/screen/cubits/logincubit/login_cubit.dart';
import 'package:yourchat/screen/login.dart';
import 'package:yourchat/widgets/chatbuble.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const scolarChat());
}

class scolarChat extends StatelessWidget {
  const scolarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          Chatpage.id: (context) => Chatpage()
        },
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.id,
      ),
    );
  }
}
