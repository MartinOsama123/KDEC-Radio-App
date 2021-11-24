import 'package:audio_service/audio_service.dart';

class QueueSystem {

 static List<MediaItem> _queue = <MediaItem>[];

 static void add(MediaItem item)  => _queue.add(item);

 static MediaItem getItem(int index)  => _queue[index];

 static bool isLast(int index)   => index == _queue.length - 1;

 static bool isFirst(int index)  => index == 0;

 static void clearQueue() => _queue.clear();

 static void isEmpty() => _queue.isEmpty;

 static void isNotEmpty() => _queue.isNotEmpty;
 static void addAll(List<MediaItem> m) => _queue.addAll(m);
 static List<MediaItem> get getQueue  => _queue;
}


