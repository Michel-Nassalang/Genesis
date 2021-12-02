// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:genesis/models/User.dart';

class ChatParams {
  final String userUid;
  final UserData peer;

  ChatParams(this.userUid, this.peer);

  String getChatGroupId(){
    if(userUid.hashCode <= peer.uid.hashCode){
      return '$userUid-${peer.uid}';
    }else{
      return '${peer.uid}-$userUid';
    }
  }
}