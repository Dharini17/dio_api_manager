import 'package:dio_api_manager/dio_api_manager.dart';
import 'package:example/ModelStudent.dart';

class StudentController {

  ModelStudent modelStudent = ModelStudent();

  Future funcGetAllStudent() async {

    return await DioApiManager.callWebservice(
      varMethodType: enumMethodType.POST,
      strSuffixPath: "getAllStudent",
      dictParameters: {"class":"1"},
    );
  }

}