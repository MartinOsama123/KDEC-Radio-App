
import 'package:chewie_audio/chewie_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player/video_player.dart';
Future<void> main() async {
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
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ChewieAudioController?  _chewieAudioController;


  final _textEditingController = TextEditingController();
  final _textEditingController1 = TextEditingController();



  void _singUp({required String email,required String password}) async {
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      print( "Signed up");
    }on FirebaseAuthException catch(e){
      print( e.message ?? "Error");
    }
  }
  void _incrementCounter() async{
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref().child("test.mp3");

    String downloadLink = await ref.getDownloadURL();
    final videoPlayerController = VideoPlayerController.network(
        downloadLink);

    await videoPlayerController.initialize();
    setState(() {
      _chewieAudioController = ChewieAudioController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    });


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
                child: _chewieAudioController != null && _chewieAudioController!.videoPlayerController.value.isInitialized
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
              ElevatedButton(onPressed: _incrementCounter, child: Text("Play")),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: _textEditingController,decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: _textEditingController1,decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),)),
              ),
              ElevatedButton(onPressed: (){
                _singUp(email: _textEditingController.text,password: _textEditingController1.text);
              }, child: Text("Sign Up")),
              Spacer(),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
