import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myeduate/features/chat/ui/widgets/customDialog.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadFile {
  ImagePicker picker = ImagePicker();

  Future<String?> onAddFileClicked(
      context, String apiBaseUrl, String filePath, File file) async {
    if (filePath != "" && file != null) {
      String fileName = filePath.split('/').last;
      print("File path: $filePath");
      print("File name: $fileName");
      String apiUrl = "$apiBaseUrl?file_name=$fileName";
      var response = await http.post(Uri.parse(apiUrl));
      var responseResult = json.decode(response.body);
      print("URL: ${responseResult.toString()}");

      var req = await http.MultipartRequest(
        'POST',
        Uri.parse(responseResult["url"]),
      );
      req.files.add(http.MultipartFile.fromBytes(
        'file',
        file.readAsBytesSync(),
        filename: fileName,
      ));
      req.fields.addAll(Map<String, String>.from(responseResult["fields"]));
      var res = await req.send();
      print('UPLOAD: ${res.statusCode}');
      return fileName;
    }
  }

  Future onSelect(context, String type) async {
    Permission permission;

    if (type == "image") {
      if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else if (type == "camera") {
      if (Platform.isIOS) {
        permission = Permission.camera;
      } else {
        permission = Permission.camera;
      }
    } else {
      if (Platform.isIOS) {
        permission = Permission.storage;
      } else {
        permission = Permission.storage;
      }
    }

    PermissionStatus permissionStatus = await permission.status;

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
//Only continue if permission granted
        return null;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
//Only continue if permission granted
        return null;
      }
    }

/* if (permissionStatus == PermissionStatus.undetermined) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }*/

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
//Only continue if permission granted
        return null;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');
      String filePath = "";
      File? file;
      XFile? image;
      List<XFile>? images;
      List files = [];
      if (type == "file") {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          filePath = result.files.single.path!;
          file = File(filePath);
        } else {
          print("Cancelled");
        }
      } else {
        if (type == "image") {
          images = await picker.pickMultiImage();
          if (images!.length == 1) {
            image = images[0];
            filePath = image.path;
            file = File(filePath);
            print('Inside Upload $file');
          } else {
            var size = 0.0;
            for (var image in images) {
              file = File(image.path);
              if (file != null) {
                int sizeInBytes = file.lengthSync();
                double sizeInMb = sizeInBytes / (1024 * 1024);
                size += sizeInMb;
                print("Size:" + size.toString());
                files.add(file);
                if (size > 16) {
                  return null;
                }
              }
            }
          }
        } else {
          image = await picker.pickImage(source: ImageSource.camera);
          filePath = image!.path;
          file = File(filePath);
        }
      }
      if (file != null) {
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 16) {
          return null;
        }
        return images != null && images.length > 1 ? files : file;
      }
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      'Permission needed',
      'Permission is needed to select files',
      'Open settings',
      openAppSettings,
    );
  }
}
