import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';

abstract class BaseMisc {
  Widget viewFxn(double height, double width, Function()? onTap,
      String? exImage, XFile? imageFile, BuildContext context);
  Widget handlePreview(String? exImage, XFile? imageFile, Widget viewFxn);
  Future<XFile?> retrieveLostData();

  Future<CroppedFile?> cropImage(File imageFile);
}

class ImageReceiptRepo implements BaseMisc {
  final ImagePicker _picker = ImagePicker();

  String? _retrieveDataError;
  dynamic _pickImageError;

  @override
  Widget viewFxn(double height, double width, Function()? onTap,
      String? exImage, XFile? imageFile, BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: exImage != null || imageFile != null
          ? Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
                  image: DecorationImage(
                    image: FileImage(File(
                      imageFile != null ? imageFile.path : exImage!,
                    )),
                    fit: BoxFit.cover,
                  )),
            )
          : Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconlyLight.image,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Pick Receipt Image',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget handlePreview(String? exImage, XFile? imageFile, Widget viewFxn) {
    return _previewImages(exImage, imageFile, viewFxn);
  }

  Widget _previewImages(String? exImage, XFile? imageFile, Widget viewFxn) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (exImage != null || imageFile != null) {
      return viewFxn;
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Future<XFile?> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file;
    } else {
      _retrieveDataError = response.exception!.code;
    }
    return null;
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Future<CroppedFile?> cropImage(File imageFile) async {
    CroppedFile? croppedFile;
    try {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: accent,
              toolbarWidgetColor: white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ],
      );

      return croppedFile;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return croppedFile;
  }
}
