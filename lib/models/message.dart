import 'package:yourchat/consts.dart';

class Message {
   String message;
   var idd;

  Message(this.message, this.idd);
  factory Message.fromJson(jsonData) {
    return Message(jsonData[kmessage], jsonData[KId]);
  }
}
