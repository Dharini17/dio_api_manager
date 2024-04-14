## dio_api_manager

dio_api_manager manage your API calls from a single place.

## Features

- Set your API base url only once in application.
- Supported HTTP method- Get, Post.
- Raw json in API call supported
- Multipart API call supported.
- Download image from it's url and it returns you downloaded path.
- Print API call log information like url, parameters, headers, file parameters.
- You can also disable logs printing.
- Easy to use with MVC structure.
- Checks internet connection with every API call.
- Handle server down or api not working errors with easy JSON response.

## Additional information

- Your API response must be in JSON format

## Getting started

Add dependency to your `pubspec.yaml` file & run Pub get

```yaml
dependencies:
  dio_api_manager: 0.0.5
```
And import package into your class file

```dart
import 'package:dio_api_manager/dio_api_manager.dart';
```


## Usage

If API response get success then function will return 3 keys,
tagName,error & jsonResponse 

If some error occurred like Internet not working or getting server error then it returns,
tagName,error & message


```dart

void main() { ...

  DioApiManager.initApiManager(

        //bearer auth header with token format
        //authorization: {"Authorization" : 'Bearer $bearerToken'},
        
        //basic auth header with username & password
        authorization: {"Authorization" : 'Basic ' + base64.encode(utf8.encode("yourUsername:yourPassword"))},
        
        baseURL: "https://demo.com/api/v1/",
        printDebugLogs: true
  );
...

  //GET,POST request
  
  Future funcGetAllStudent() {

       return await DioApiManager.callWebservice(
                            varMethodType: enumMethodType.GET,//enumMethodType.POST,
                            strSuffixPath: "getAllStudent",
                            dictParameters: {"class":"1"},
                    );
  }  
  
  //POST request with Raw json
  
  Future funcGetAllStudent() {

       return await DioApiManager.callWebservice(
                            varMethodType: enumMethodType.POST,
                            strSuffixPath: "getAllStudent",
                            dictParameters: {"class":"1"},
                            isRawJson: true
                    );
  }
  
  //multipart POST request
  
    Future funcUpdateProfileAPICall() async {
    
    return await DioApiManager.callWebservice(
                varMethodType: enumMethodType.POST,
                strSuffixPath: "updateProfile",
                dictParameters: {"id":"1","name":"xyz"},
                arrayUploadFile: ModelUploadFile(name: "profileImage", xFile: 'file', xFileName: "profiledp.png")
           );
    }
  
  //download image like 
  String downloadedPath = await DioApiManager.funcDownLoadFile(imageURL: "your image url in string");
  
  //example of using internet or server error or API not working errors with future builder

  
```