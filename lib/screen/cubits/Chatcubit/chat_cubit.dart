import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:yourchat/consts.dart';
import 'package:yourchat/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(Kmassagecollection);
  void sendmessage({required String message, required var email}) {
    try {
      messages.add({kmessage: message, kcreatAt: DateTime.now(), KId: email});
    } on Exception catch (e) {}
  }

  void getmessage() {
    messages.orderBy(kcreatAt, descending: true).snapshots().listen(
      (event) {
        List<Message> messagelist = [];
        messagelist.clear();
        for (var doc in event.docs) {
          messagelist.add(Message.fromJson(doc));
        }
        // print("======");
        emit(ChatSuccess(messages: messagelist));
      },
    );
  }
}
