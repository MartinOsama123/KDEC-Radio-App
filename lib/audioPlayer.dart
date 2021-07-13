import 'package:chewie_audio/chewie_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}*/

class FirebaseList extends StatefulWidget {
  FirebaseList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FirebaseListState createState() => _FirebaseListState();
}

class _FirebaseListState extends State<FirebaseList> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ChewieAudioController? _chewieAudioController;



 /* void _singUp({required String email, required String password}) async {
    try {
      *//*await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      print("Signed up");*//*
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e.message ?? "Error");
    }
  }*/

  Future<List<firebase_storage.Reference>> getAllAlbums() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();
    return result.prefixes.toList();
    //  String downloadLink = await ref.getDownloadURL();
    /* final videoPlayerController = VideoPlayerController.network(downloadLink);

    await videoPlayerController.initialize();
    setState(() {
      _chewieAudioController = ChewieAudioController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    });*/
  }

  @override
  void dispose() {
    _chewieAudioController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _chewieAudioController != null &&
                        _chewieAudioController!
                            .videoPlayerController.value.isInitialized
                    ? ChewieAudio(
                        controller: _chewieAudioController!,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
              //     ElevatedButton(onPressed: _getAllFiles, child: Text("Play")),
              /*  Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
              ),
              ElevatedButton(
                  onPressed: () {
                    _singUp(
                        email: _textEditingController.text,
                        password: _textEditingController1.text);
                  },
                  child: Text("Sign Up")),
              Spacer(),*/
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
