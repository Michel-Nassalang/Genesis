// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genesis/models/Message.dart';

class MessageDatabaseService {

final CollectionReference smsCollection =
      FirebaseFirestore.instance.collection("Messages");

  Stream <Iterable<Message>> getMessage(String grouchatId, int limit){
    return smsCollection
          .doc(grouchatId)
          .collection(grouchatId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots().map(_messageListFromSnapshot);
  }

  Iterable<Message> _messageListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) => _messageFromSnapshot(doc));
  }
  Message _messageFromSnapshot(DocumentSnapshot snapshot){
    if(snapshot.data() == null) throw Exception('Message non trouvé');
    return Message(
      idFrom: snapshot.get('idFrom'),
      idTo : snapshot.get('idTo'),
      timestamp : snapshot.get('timestamp'),
      content : snapshot.get('content'),
      type : snapshot.get('type'),
      view: snapshot.get('view')
    );
  } 
  
  void onSendMessage(String grouchatId, Message message) {
    var documentReference = smsCollection
    .doc(grouchatId)
    .collection(grouchatId)
    .doc(DateTime.now().microsecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.tohashMap());
    });
  }

  Future<bool> lien(String connect) async {
    try {
      var doc = await smsCollection.doc(connect).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  void statutSMS(String grouchatId) {
    var documentReference = smsCollection
        .doc(grouchatId)
        .collection(grouchatId)
        .doc(DateTime.now().microsecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {'view': true});
    });
  }

}
