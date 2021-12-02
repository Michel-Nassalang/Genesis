// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:genesis/models/User.dart';
import 'package:genesis/screens/init.dart';
import 'package:genesis/services/authentification.dart';
import 'package:provider/provider.dart';

class SettingsModel extends StatefulWidget {
  const SettingsModel({Key? key}) : super(key: key);

  @override
  _SettingsModelState createState() => _SettingsModelState();
}

class _SettingsModelState extends State<SettingsModel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final AuthentificationService _auth = AuthentificationService();
  void logout() async {
    await _auth.sOut().then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const Initial())));
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
        value: AuthentificationService().user,
        initialData: null,
        child: Center(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 100)),
              const Text('Paramètres'),
              IconButton(icon: const Icon(Icons.logout), onPressed: logout)
            ],
          ),
        ));
  }
}
