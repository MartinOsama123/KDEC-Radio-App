import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();

  onStart(Map<String, dynamic>? params) async {
    final mediaItem = MediaItem(
      id: params?['url'] ?? "0",
      album: params?['album'] ?? "",
      title: params?['title'] ?? "",
    );
    // Tell the UI and media notification what we're playing.
    AudioServiceBackground.setMediaItem(mediaItem);
    print('entered');
    AudioServiceBackground.setState(controls: [AudioServiceBackground.state.playing ? MediaControl.pause : MediaControl.play,MediaControl.stop],playing: true,processingState: AudioProcessingState.connecting);
    _player.setUrl(params!['url']);
    _player.play();

    AudioServiceBackground.setState(controls: [MediaControl.pause,MediaControl.stop],playing: true,processingState: AudioProcessingState.ready);
  }
  @override
  Future<void> onStop() async {
    AudioServiceBackground.setState(playing: false,processingState: AudioProcessingState.stopped);
    await _player.stop();
    return super.onStop();
  }
  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(controls: [MediaControl.pause,MediaControl.stop],playing: true,processingState: AudioProcessingState.ready);

    await _player.play();
    return super.onPlay();
  }
  @override
  Future<void> onPause() async {
    AudioServiceBackground.setState(controls: [MediaControl.play,MediaControl.stop],playing: false,processingState: AudioProcessingState.ready);
    await _player.pause();
    return super.onPause();
  }
  @override
  Future<void> onClose() {
    _player.stop();
    AudioService.disconnect();
    return super.onClose();
  }
}