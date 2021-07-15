import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:core';
class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();

  onStart(Map<String, dynamic>? params) async {
   await _player.setUrl(params!['url']);
   print("seconds: ${_player.duration!.inSeconds}");
    final mediaItem = MediaItem(
      id: params?['url'] ?? "0",
      album: params?['album'] ?? "",
      title: params?['title'] ?? "",
      duration: _player.duration
    );
    // Tell the UI and media notification what we're playing.
    AudioServiceBackground.setMediaItem(mediaItem);
    print('entered');
    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,

    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.connecting);

    _player.play();

    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,

    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onStop() async {
    await _player.dispose();
    return super.onStop();
  }

  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,

    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.ready);

    await _player.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.play,
      MediaControl.stop,
      MediaControl.skipToNext,
    ], systemActions: [
      MediaAction.seekTo
    ], playing: false, processingState: AudioProcessingState.ready);
    _player.pause();
    return super.onPause();
  }
  @override
  Future<void> onSeekTo(Duration position) {
    _player.seek(position);
    AudioServiceBackground.setState(position: position);
    return super.onSeekTo(position);
  }
}
