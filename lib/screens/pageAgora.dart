import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PageAgora extends StatefulWidget {
  const PageAgora({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PageAgoraState();
}

class PageAgoraState extends State<PageAgora> {
  final _channelController = TextEditingController();

  bool _validateError = false;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Genesis\' Call'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/genesis_flex.jpg'),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text(
                  'Genesis\' Call',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _channelController,
                    decoration: InputDecoration(
                      labelText: 'Nom de Canal',
                      labelStyle: const TextStyle(color: Colors.blue),
                      hintText: 'test',
                      hintStyle: const TextStyle(color: Colors.black45),
                      errorText:
                          _validateError ? 'Nom du canal obligatoire' : null,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: MaterialButton(
                    onPressed: onJoin,
                    height: 40,
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'Joindre',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    !_validateError
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container() /* VideoCall() */, 
            ))
        : null;
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    var permissionStatus = await permission.request();
  }
}
