import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:genesis/common/loading.dart';
import 'package:genesis/models/Message.dart';
import 'package:genesis/models/TextChat.dart';
import 'package:genesis/models/User.dart';
import 'package:genesis/models/chat-params.dart';
import 'package:genesis/screens/expandable.dart';
import 'package:genesis/services/messageDatabase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Discussion extends StatefulWidget {
  final UserData ActuUser;
  const Discussion({Key? key, required this.ActuUser}) : super(key: key);

  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final messageControl = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final MessageDatabaseService messageService = MessageDatabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => StatutAjour);
    _controller = AnimationController(vsync: this);
    listScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    messageControl.dispose();
    listScrollController.dispose();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _nbElement += pagination;
      });
    }
  }

  Future<void> onSendMessage(String present, String content, int type) async {
    if (content.trim() != '') {
      messageService.onSendMessage(
          ChatParams(present, widget.ActuUser).getChatGroupId(),
          Message(
              idFrom: present,
              idTo: widget.ActuUser.uid,
              timestamp: DateTime.now().microsecondsSinceEpoch.toString(),
              content: content,
              type: type,
              view: false));
      await listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      messageControl.clear();
    } else {
      Fluttertoast.showToast(
        msg: 'Pas de message à envoyer',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> StatutAjour(String present) async {
    messageService
        .statutSMS(ChatParams(present, widget.ActuUser).getChatGroupId());
  }

  Future<void> getImage(String present) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // setState(() {
      //   isloading = true;
      // });
      uploadFile(present, pickedFile);
    }
  }

  Future uploadFile(String pre, PickedFile picked) async {
    String fileName =
        DateTime.now().microsecondsSinceEpoch.toString() + '.jpeg';
    try {
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': picked.path});
      TaskSnapshot snapshot;
      if (kIsWeb) {
        snapshot =
            await reference.putData(await picked.readAsBytes(), metadata);
      } else {
        snapshot = await reference.putFile(File(picked.path), metadata);
      }
      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        onSendMessage(pre, imageUrl, 2);
      });
    } on Exception {
      Fluttertoast.showToast(
          msg: 'Une erreur est parvenue lors de l\'importation',
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  void deploiement(bool val) {
    setState(() {
      val = !val;
    });
  }

  bool isDeploie = false;
  int _nbElement = 50;
  static const int pagination = 50;

  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Material(
          color: Colors.white,
          child: StreamBuilder<Iterable<Message>>(
            stream: messageService.getMessage(
                ChatParams(utilisateur!.uid, widget.ActuUser).getChatGroupId(),
                _nbElement),
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<Message>> snapshot) {
              if (snapshot.hasData) {
                Iterable<Message> listMessage =
                    snapshot.data ?? Iterable.castFrom([]);
                return ListView.builder(
                  itemCount: listMessage.length,
                  itemBuilder: (context, int index) {
                    return TextMessage(
                        message: listMessage.elementAt(index),
                        precedent: (index != 0)
                            ? listMessage.elementAt(index - 1)
                            : listMessage.elementAt(index));
                  },
                  reverse: true,
                  controller: listScrollController,
                  padding: const EdgeInsets.only(bottom: 65),
                );
              } else {
                return const Center(child: Loading());
              }
            },
          )),
      floatingActionButton: ExpandableFab(distance: 175, children: [
        const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.file_present),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.audiotrack),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        const FloatingActionButton(onPressed: null, child: Icon(Icons.camera)),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        FloatingActionButton(
          onPressed: () {
            getImage(utilisateur.uid);
          },
          child: const Icon(Icons.image),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.video_collection),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 50))
      ]),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20 / 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: Colors.blue.withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              const Icon(Icons.mic, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20 * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.64),
                      ),
                      const SizedBox(width: 20 / 4),
                      Expanded(
                        child: TextField(
                          controller: messageControl,
                          decoration: const InputDecoration(
                            hintText: "Ecrire un message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                          onPressed: null,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: kMinInteractiveDimension,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 25 / 4),
              IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    onSendMessage(
                        utilisateur.uid, messageControl.value.text, 1);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  constraints: const BoxConstraints(
                    minWidth: 26,
                    minHeight: kMinInteractiveDimension,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/genesis_flex.jpg"),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.ActuUser.name,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                widget.ActuUser.statut == 'active'
                    ? 'En ligne'
                    : 'Depuis  ${widget.ActuUser.statut}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
      ],
    );
  }
}

