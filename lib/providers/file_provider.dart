import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickture/providers/auth_provider.dart';

final fileNotifierProvider = ChangeNotifierProvider<FileNotifier>((ref) => FileNotifier(ref));

class FileNotifier extends ChangeNotifier {
  FileNotifier(this._ref);

  final Ref _ref;
  File? _file;
  double _uploadProgress = 0;
  String? _downloadUrl;

  File? get file => _file;
  double get uploadProgress => _uploadProgress;
  String? get downloadUrl => _downloadUrl;

  void setFile(File? file) {
    _file = file;
    notifyListeners();
  }

  void setUploadProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void setDownloadUrl(String url) {
    _downloadUrl = url;
    notifyListeners();
  }

  Future<void> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setFile(File(pickedFile.path));
    }
  }

  Future<void> uploadFile() async {
    final filePath = "Uploads/${DateTime.now().toIso8601String()}_${_file!.path.split('/').last}";
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    final uploadTask = storageRef.putFile(file!);
    final taskSnapshot = await uploadTask;

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      setUploadProgress(progress);
    });

    await uploadTask.whenComplete(() {
      setUploadProgress(100);
    });

    String url = await taskSnapshot.ref.getDownloadURL();
    setDownloadUrl(url);
  }

  Future<void> uploadProfileImage(Uint8List data) async {
    var uid = _ref.read(authProvider).value?.uid;
    if (uid == null) return;

    final filePath = "ProfileImage/$uid";
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    final uploadTask = storageRef.putData(data);
    final taskSnapshot = await uploadTask;

    String url = await taskSnapshot.ref.getDownloadURL();
    await _ref.read(authProvider.notifier).updateProfileImage(url);
  }
}
