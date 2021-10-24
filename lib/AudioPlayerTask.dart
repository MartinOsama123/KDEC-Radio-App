/*
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:core';

import 'QueueSystem.dart';

class AudioPlayerTask extends  BaseAudioHandler
with QueueHandler, // mix in default queue callback implementations
SeekHandler {
  int _current = 0;
  late List<MediaItem> _list;
  final _player = AudioPlayer();

  onStart(Map<String, dynamic>? params) async {
    _list =  (jsonDecode(params!['list']) as List).map((i) => MediaItem.fromJson(i)).toList();
    _current = (jsonDecode(params['current']));

 //  final MediaItem mediaItem = new MediaItem(id: params['url'], album: params['album'], title: params['title'],duration: _player.duration);
    print(_list[_current]);
    await AudioServiceBackground.setMediaItem(_list[_current]);

    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.skipToNext,
    ], systemActions: [
      MediaAction.seek
    ], playing: true, processingState: AudioProcessingState.connecting);
    if(_list[_current].id != "live") {
      DefaultCacheManager().getSingleFile(_list[_current].id);

      await _player.setUrl(_list[_current].id);
    }
      _player.play();

      AudioServiceBackground.setState(controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,

      ], systemActions: [
        MediaAction.seek
      ], playing: true, processingState: AudioProcessingState.ready);

 */
/*AudioServiceBackground.setState(controls: [MediaControl.stop],playing: true, processingState: AudioProcessingState.ready);*//*


  }

  @override
  Future<void> onStop() async {
    await _player.dispose();

  }

  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,

      MediaControl.skipToNext,

    ], systemActions: [
      MediaAction.seek
    ], playing: true, processingState: AudioProcessingState.ready);

    await _player.play();

  }

  @override
  Future<void> onPause() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.skipToPrevious,
      MediaControl.play,
      MediaControl.skipToNext,
    ], systemActions: [
      MediaAction.seek
    ], playing: false, processingState: AudioProcessingState.ready);
    await _player.pause();

  }
  @override
  Future<void> onSeek(Duration position) async {
    _player.seek(position);
    AudioServiceBackground.setState(position: position);
  }
  @override
   Future<void> onSkipToNext() async {
    _current == _list.length - 1 ? _current = 0 : _current += 1;
    AudioServiceBackground.setMediaItem(_list[_current]);
    await _player.setUrl(_list[_current].id);
    AudioServiceBackground.setState(position: Duration.zero);

  }
  @override
  Future<void> onSkipToPrevious() async {
    _current == 0 ? _current = _list.length-1 : _current -= 1;
    AudioServiceBackground.setMediaItem(_list[_current]);
    await _player.setUrl(_list[_current].id);
    AudioServiceBackground.setState(position: Duration.zero);

  }

}


*/
