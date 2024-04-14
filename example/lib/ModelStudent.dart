class ModelStudent {
  List<StudentData>? studentData;

  ModelStudent({this.studentData});

  ModelStudent.fromJson(Map<String, dynamic> json) {
    if (json['studentData'] != null) {
      studentData = <StudentData>[];
      json['studentData'].forEach((v) {
        studentData!.add(new StudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentData != null) {
      data['studentData'] = this.studentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentData {
  String? rollNo;
  String? studentName;

  StudentData({this.rollNo, this.studentName});

  StudentData.fromJson(Map<String, dynamic> json) {
    rollNo = json['rollNo'];
    studentName = json['studentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rollNo'] = this.rollNo;
    data['studentName'] = this.studentName;
    return data;
  }
}
