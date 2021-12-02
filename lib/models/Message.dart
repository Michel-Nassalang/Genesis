// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

class Message {
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;
  final bool view;

  Message(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      required this.type,
      required this.view});

  Map<String, dynamic> tohashMap() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'type': type, 
      'view': view,
    };
  }
  Map<String, dynamic> tonewMap() {
    return {
      'view': view,
    };
  }
}
