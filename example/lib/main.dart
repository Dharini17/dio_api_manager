import 'dart:convert';
import 'package:dio_api_manager/dio_api_manager.dart';
import 'package:example/ModelStudent.dart';
import 'package:example/StudentController.dart';
import 'package:example/Utility.dart';
import 'package:flutter/material.dart';

void main() {

  DioApiManager.initApiManager(

      //bearer auth header with token format
      //authorization: {"Authorization" : 'Bearer $bearerToken'},

      //basic auth header with username & password
      authorization: {"Authorization" : 'Basic ' + base64.encode(utf8.encode("yourUsername:yourPassword"))},

      baseURL: "https://demo.com/api/v1/",
      printDebugLogs: true
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DioApiManager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StudentController studentController = StudentController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar( backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: const Text("DioApiManager demo",),
      ),
      body: FutureBuilder<dynamic>(
        future: studentController.funcGetAllStudent(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          switch (snapshot.connectionState) {

            case ConnectionState.waiting:
              return Utility.funcLoaderFuture();

            default: {

              if (snapshot.hasError) {
                return Utility.funcFutureBuilderError(isInternetCheck: true, onTryAgain: () {
                  setState(() {});
                });
              }
              else {

                print(snapshot.data);

                if(snapshot.data['error'] == true) {
                  return Utility.funcFutureBuilderError(isInternetCheck: false,onTryAgain: (){
                    setState(() {});
                  });
                }

                else{

                  //-----------------------------------------------------------
                  //to fina model class error from logs write it without try catch block
                  //studentController.modelStudent = ModelStudent.fromJson(snapshot.data['jsonResponse']);

                  //-----------------------------------------------------------
                  //best practice to prevent live apps from getting error is to write within try catch
                  //so flutter red page error do not directly show to our app users

                  try {
                    studentController.modelStudent = ModelStudent.fromJson(snapshot.data['jsonResponse']);
                  } catch (_) {

                    // handling json to model conversion error in case of data type conversion
                    // or null type error
                    // or your json format is wrong with model class
                    return Utility.funcFutureBuilderError(isInternetCheck: false,onTryAgain: (){
                      setState(() {});
                    });
                  }
                return ListView.builder(
                  itemCount: studentController.modelStudent.studentData!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Text(studentController.modelStudent.studentData![index].studentName!),
                    );
                  },
                );}

              }
            }
          }
        },
      ),
    );
  }
}
