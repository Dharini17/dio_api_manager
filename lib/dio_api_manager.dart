library dio_api_manager;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

enum enumMethodType { GET, POST }

ValueNotifier<Map<String,dynamic>> authorizationHeader = ValueNotifier({});
ValueNotifier<String> prefixURL = ValueNotifier("");
ValueNotifier<bool> isPrintAPILog = ValueNotifier(false);

class DioApiManager {

  static initApiManager({required Map<String,dynamic> authorization,required String baseURL,required bool printDebugLogs}){
    authorizationHeader.value = authorization;
    prefixURL.value = baseURL;
    isPrintAPILog.value = printDebugLogs;
  }

  static Future callWebservice(
      {
        required enumMethodType varMethodType,
        required String strSuffixPath,
        required Map<String, String> dictParameters,
        bool isRawJson = false,
        List<ModelUploadFile>? arrayUploadFile,
      }) async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        Dio dio = Dio();

        dio.options.connectTimeout = const Duration(seconds: 5);
        dio.options.receiveTimeout = const Duration(seconds: 5);

        dio.options.headers = authorizationHeader.value;

        switch (varMethodType) {

          case enumMethodType.GET:
            {

              if(isPrintAPILog.value) {
                print("-------------------------------------------------------------------------");
                print("TYPE : ${enumMethodType.GET}");
                print("API : ${prefixURL.value + strSuffixPath}");
                print("HEADERS : ${dio.options.headers}");
                print("PARAMETERS : $dictParameters");
                print("-------------------------------------------------------------------------");
              }

              try {

                final response = await dio.get(prefixURL.value + strSuffixPath ,queryParameters: dictParameters,);

                if(isPrintAPILog.value) {
                  print("Response : $response");     }

                if (response.statusCode == 200) {
                  //api checking starts here

                  Map<String, dynamic> varJsonData = json.decode("${response}");

                  return {"tagName":strSuffixPath,"error": false, "jsonResponse": varJsonData};

                } else {

                  return {

                    "tagName":strSuffixPath,
                    "error": true,
                    "message": "Something went wrong, please try after sometime."
                  };

                } //api checking ends here

              }
              catch (_) { // <-- removing the on Exception clause
                return {
                  "tagName": strSuffixPath,
                  "error": true,
                  "message": "Something went wrong, please try after sometime."
                };
              }
            }
            break;

          case enumMethodType.POST:
            {

              Map<String,dynamic> dictFormData =  Map<String,dynamic>();
              if(!isRawJson) {
                dictParameters.forEach((key, value) =>
                dictFormData[key] = value);

                if (arrayUploadFile != null) {
                  for (int j = 0; j < arrayUploadFile.length; j++) {
                    dictFormData.addAll({
                      "${arrayUploadFile[j].name}": await MultipartFile
                          .fromFile(
                          (arrayUploadFile[j].xFile as XFile).path,
                          filename: "${arrayUploadFile[j].xFileName}"),
                    });
                  }
                }
              }
              FormData varFormData = FormData.fromMap(dictFormData);

              if(isPrintAPILog.value) {
                print("-------------------------------------------------------------------------");
                print("TYPE : ${enumMethodType.POST}");
                print("API : ${prefixURL.value + strSuffixPath}");
                print("HEADERS : ${dio.options.headers}");
                print("PARAMETERS : ${isRawJson ? dictParameters : dictFormData}");

                if(arrayUploadFile != null){
                  print("FILES : $arrayUploadFile");
                }
                print("-------------------------------------------------------------------------");
              }

              try {
                final jsonResponse = await dio
                    .post(prefixURL.value + strSuffixPath,
                    data: isRawJson ? jsonEncode(dictParameters) : varFormData,
                    options: Options(
                        method: 'POST',
                        responseType:
                        ResponseType.json // or ResponseType.JSON
                    ));

                if(isPrintAPILog.value) {
                  print("Response : $jsonResponse");     }

                if (jsonResponse.statusCode == 200) {
                  return {
                    "tagName": strSuffixPath,
                    "error": false,
                    "jsonResponse": jsonDecode("${jsonResponse}")
                  };
                } else {
                  return {
                    "tagName": strSuffixPath,
                    "error": true,
                    "message": "Something went wrong, please try after sometime."
                  };
                }

              }
              catch (_) { // <-- removing the on Exception clause
                return {
                  "tagName": strSuffixPath,
                  "error": true,
                  "message": "Something went wrong, please try after sometime."
                };
              }//api checking ends here

            }
            break;

          default:
            print('');
        }
      }
    } on SocketException catch (_) {
      return {"tagName":strSuffixPath,"error": true, "message": "Please check your internet connection."};
    }
  }

  static Future funcDownLoadFile({required String imageURL}) async {

    String directory = (await getApplicationDocumentsDirectory()).path;
    String filePath = '$directory/${funcGetUniqueFileName()}${imageURL.substring(imageURL.lastIndexOf("."))}';

    print(filePath);

    await Dio().downloadUri(Uri.parse(imageURL), filePath);
    return filePath;

  }

  static String funcGetUniqueFileName() {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return "${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}${List.generate(6, (index) => _chars[r.nextInt(_chars.length)]).join()}";
  }

}

class ModelUploadFile{

  String name;
  XFile  xFile;
  String xFileName;

  ModelUploadFile({required this.name,required this.xFile,required this.xFileName});

}
