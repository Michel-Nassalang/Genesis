// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:genesis/common/loading.dart';
import 'package:genesis/models/Message.dart';
import 'package:genesis/models/User.dart';
import 'package:genesis/screens/imageAffichage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, required this.message, required this.precedent})
      : super(key: key);

  final Message message;
  final Message precedent;

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Suppression', style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ListBody(
              mainAxis: Axis.vertical,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person_remove_rounded),
                    onPressed: () {},
                    label: const Text(
                      'Supprimer pour moi',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton.icon(
                  icon: const Icon(Icons.group_outlined),
                    onPressed: () {},
                    label: const Text('Supprimer pour tous',
                        style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userpresent = Provider.of<AppUser?>(context);
    final temps1 = int.parse(DateFormat('dd').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(message.timestamp))));
    final temps2 = int.parse(DateFormat('dd').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(precedent.timestamp))));
    final annee1 = int.parse(DateFormat('yyyy').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(message.timestamp))));
    final annee2 = int.parse(DateFormat('yyyy').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(precedent.timestamp))));
    return Column(children: [
      
      annee1 != annee2
          ? Center(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 7.5, bottom: 7.5),
                decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                    DateFormat('yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            int.parse(message.timestamp))),
                    style: GoogleFonts.lato(
                        color: Colors.white, fontStyle: FontStyle.italic)),
              ),
            )
          : const Padding(padding: EdgeInsets.zero),
      temps1 != temps2
          ? Center(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 7.5, bottom: 7.5),
                decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                    DateFormat('dd MMMM').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            int.parse(message.timestamp))),
                    style: GoogleFonts.lato(
                        color: Colors.white, fontStyle: FontStyle.italic)),
              ),
            )
          : const Padding(padding: EdgeInsets.zero),
      Row(
        children: [
          message.idFrom == userpresent!.uid
              ? const Expanded(child: Padding(padding: EdgeInsets.zero))
              : const Padding(padding: EdgeInsets.zero),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: 20 * 0.75,
                vertical: 20 / 2,
              ),
              margin: message.idFrom == userpresent.uid
                  ? const EdgeInsets.fromLTRB(100, 3, 5, 3)
                  : const EdgeInsets.fromLTRB(5, 3, 100, 3),
              decoration: BoxDecoration(
                color: message.idFrom == userpresent.uid
                    ? Colors.grey[300]
                    : Colors.blue[100],
                borderRadius: message.idFrom == userpresent.uid
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.elliptical(-35, -65))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.elliptical(-35, -65),
                        bottomRight: Radius.circular(10)),
              ),
              child: message.type != 2
                  ? GestureDetector(
                      onLongPress: () => _showMyDialog(context),
                      child: Text(
                        message.content,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          color: (message.idFrom == userpresent.uid)
                              ? Colors.black
                              : Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onLongPress: () => _showMyDialog(context),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageAffiche(img: message),
                          )),
                      child: Image.network(message.content, loadingBuilder:
                          (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                              color: (message.idFrom == userpresent.uid)
                                  ? Colors.black
                                  : Colors.black,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              )),
                          width: 200.0,
                          height: 200.0,
                          child: const Center(
                            child: Loading(),
                          ),
                        );
                      }, errorBuilder: (context, object, stackTrace) {
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          child: const SpinKitFadingCube(
                            color: Colors.blue,
                            size: 40,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          clipBehavior: Clip.hardEdge,
                        );
                      }, width: 200.0, height: 200.0, fit: BoxFit.cover),
                    ),
              clipBehavior: Clip.hardEdge,
            ),
              Padding(
                padding: message.idFrom == userpresent.uid
                    ? const EdgeInsets.fromLTRB(100, 3, 5, 3)
                    : const EdgeInsets.fromLTRB(5, 3, 100, 3),
                child: Text(
                  DateFormat('HH:mm').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(message.timestamp))),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontStyle: FontStyle.italic),
                ),
              )
          ]),
          message.idFrom == userpresent.uid
              ? const Padding(padding: EdgeInsets.zero)
              : const Expanded(child: Padding(padding: EdgeInsets.zero)),
        ],
      ),
    ]);
  }
}
