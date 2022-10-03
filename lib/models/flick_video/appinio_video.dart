import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genesis/models/Message.dart';
import 'package:genesis/models/User.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppinioVideo extends StatefulWidget {
  const AppinioVideo({ Key? key, required this.message }) : super(key: key);
  final Message message;

  @override
  State<AppinioVideo> createState() => _AppinioVideoState();
}

class _AppinioVideoState extends State<AppinioVideo> {
  
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController customVideoPlayerController ;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(
    controlBarAvailable: true,
    controlBarPadding: EdgeInsets.all(0),
    showPlayButton: true,
    playButton: Icon(
      Icons.play_circle,
      color: Colors.white,
    ),
    enterFullscreenButton: Icon(
      Icons.fullscreen,
      color: Colors.white,
    ),
    exitFullscreenButton: Icon(
      Icons.fullscreen_exit,
      color: Colors.white,
    ),
    systemUIModeAfterFullscreen: SystemUiMode.leanBack,
    systemUIModeInsideFullscreen: SystemUiMode.edgeToEdge,
  );


  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.message.content)
      ..initialize().then((value) => setState(() {}));
    customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: buildAppBar(),
       body : GestureDetector(
         onVerticalDragCancel: (){Navigator.pop(context);},
         child: SafeArea(child: Center(
           child: SizedBox(
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height,
             child: CustomVideoPlayer(
                customVideoPlayerController: CustomVideoPlayerController(
                   context: context,
                   videoPlayerController: _videoPlayerController,
                   customVideoPlayerSettings: _customVideoPlayerSettings
                 ),
               ),
           ),
         ),),
       )
     );
    
  }
  buildAppBar() {
    final userpresent = Provider.of<AppUser?>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message.idFrom == userpresent!.uid ? 'Vous' : 'A vous',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                  DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(widget.message.timestamp))),
                  style: const TextStyle(
                    fontSize: 12,
                  ))
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.star_border_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        PopupMenuButton<String>(
          onSelected: null,
          itemBuilder: (BuildContext context) {
            return {'Details', 'Caractéristiques'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}