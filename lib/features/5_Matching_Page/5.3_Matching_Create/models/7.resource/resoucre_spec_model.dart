// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResourceSpecModel {
  BilliardTableSpec? billiardTable;
  PCSpec? pc;
  ConsoleSpec? console;

  ResourceSpecModel({
    this.billiardTable,
    this.pc,
    this.console,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'billiardTable': billiardTable?.toMap(),
      'pc': pc?.toMap(),
      'console': console?.toMap(),
    };
  }

  factory ResourceSpecModel.fromMap(Map<String, dynamic> map) {
    return ResourceSpecModel(
      billiardTable: map['billiardTable'] != null
          ? BilliardTableSpec.fromMap(
              map['billiardTable'] as Map<String, dynamic>)
          : null,
      pc: map['pc'] != null
          ? PCSpec.fromMap(map['pc'] as Map<String, dynamic>)
          : null,
      console: map['console'] != null
          ? ConsoleSpec.fromMap(map['console'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceSpecModel.fromJson(Map<String, dynamic> source) =>
      ResourceSpecModel.fromMap(source);
}

/// Spec cho Bàn Bida
class BilliardTableSpec {
  String? btTableDetail;
  String? btCueDetail;
  String? btBallDetail;

  BilliardTableSpec({this.btTableDetail, this.btCueDetail, this.btBallDetail});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'btTableDetail': btTableDetail,
      'btCueDetail': btCueDetail,
      'btBallDetail': btBallDetail,
    };
  }

  factory BilliardTableSpec.fromMap(Map<String, dynamic> map) {
    return BilliardTableSpec(
      btTableDetail:
          map['btTableDetail'] != null ? map['btTableDetail'] as String : null,
      btCueDetail:
          map['btCueDetail'] != null ? map['btCueDetail'] as String : null,
      btBallDetail:
          map['btBallDetail'] != null ? map['btBallDetail'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BilliardTableSpec.fromJson(Map<String, dynamic> source) =>
      BilliardTableSpec.fromMap(source);
}

/// Spec cho Máy tính (PC)
class PCSpec {
  String? pcCpu;
  String? pcRam;
  String? pcGpu;
  String? pcMonitor;
  String? pcKeyboard;
  String? pcMouse;
  String? pcHeadphone;

  PCSpec({
    this.pcCpu,
    this.pcRam,
    this.pcGpu,
    this.pcMonitor,
    this.pcKeyboard,
    this.pcMouse,
    this.pcHeadphone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pcCpu': pcCpu,
      'pcRam': pcRam,
      'pcGpu': pcGpu,
      'pcMonitor': pcMonitor,
      'pcKeyboard': pcKeyboard,
      'pcMouse': pcMouse,
      'pcHeadphone': pcHeadphone,
    };
  }

  factory PCSpec.fromMap(Map<String, dynamic> map) {
    return PCSpec(
      pcCpu: map['pcCpu'] != null ? map['pcCpu'] as String : null,
      pcRam: map['pcRam'] != null ? map['pcRam'] as String : null,
      pcGpu: map['pcGpu'] != null ? map['pcGpu'] as String : null,
      pcMonitor: map['pcMonitor'] != null ? map['pcMonitor'] as String : null,
      pcKeyboard:
          map['pcKeyboard'] != null ? map['pcKeyboard'] as String : null,
      pcMouse: map['pcMouse'] != null ? map['pcMouse'] as String : null,
      pcHeadphone:
          map['pcHeadphone'] != null ? map['pcHeadphone'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PCSpec.fromJson(Map<String, dynamic> source) =>
      PCSpec.fromMap(source);
}

/// Spec cho Console (PS5)
class ConsoleSpec {
  String? csConsoleModel;
  String? csTvModel;
  String? csControllerType;
  int? csControllerCount;

  ConsoleSpec({
    this.csConsoleModel,
    this.csTvModel,
    this.csControllerType,
    this.csControllerCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'csConsoleModel': csConsoleModel,
      'csTvModel': csTvModel,
      'csControllerType': csControllerType,
      'csControllerCount': csControllerCount,
    };
  }

  factory ConsoleSpec.fromMap(Map<String, dynamic> map) {
    return ConsoleSpec(
      csConsoleModel: map['csConsoleModel'] != null
          ? map['csConsoleModel'] as String
          : null,
      csTvModel: map['csTvModel'] != null ? map['csTvModel'] as String : null,
      csControllerType: map['csControllerType'] != null
          ? map['csControllerType'] as String
          : null,
      csControllerCount: map['csControllerCount'] != null
          ? map['csControllerCount'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsoleSpec.fromJson(Map<String, dynamic> source) =>
      ConsoleSpec.fromMap(source);
}
