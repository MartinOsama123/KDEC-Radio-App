import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FirebaseQueries {
  static Future<List<firebase_storage.Reference>> getAllAlbums() async {
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref().listAll();
    print(result.prefixes.length);
    return result.prefixes.toList();
  }
  static Future<List<firebase_storage.Reference>> getAlbumPlaylist(String albumName) async {
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref().child(albumName).listAll();
    return result.items.toList();
  }
  static Future<String> getMp3Link(String fullPath) async {
    return await firebase_storage.FirebaseStorage.instance.ref().child(fullPath).getDownloadURL();
  }
}