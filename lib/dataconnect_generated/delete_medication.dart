part of 'example.dart';

class DeleteMedicationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteMedicationVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteMedicationData> dataDeserializer = (dynamic json)  => DeleteMedicationData.fromJson(jsonDecode(json));
  Serializer<DeleteMedicationVariables> varsSerializer = (DeleteMedicationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteMedicationData, DeleteMedicationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteMedicationData, DeleteMedicationVariables> ref() {
    DeleteMedicationVariables vars= DeleteMedicationVariables(id: id,);
    return _dataConnect.mutation("DeleteMedication", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteMedicationMedicationDelete {
  final String id;
  DeleteMedicationMedicationDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMedicationMedicationDelete otherTyped = other as DeleteMedicationMedicationDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteMedicationMedicationDelete({
    required this.id,
  });
}

@immutable
class DeleteMedicationData {
  final DeleteMedicationMedicationDelete? medication_delete;
  DeleteMedicationData.fromJson(dynamic json):
  
  medication_delete = json['medication_delete'] == null ? null : DeleteMedicationMedicationDelete.fromJson(json['medication_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMedicationData otherTyped = other as DeleteMedicationData;
    return medication_delete == otherTyped.medication_delete;
    
  }
  @override
  int get hashCode => medication_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (medication_delete != null) {
      json['medication_delete'] = medication_delete!.toJson();
    }
    return json;
  }

  DeleteMedicationData({
    this.medication_delete,
  });
}

@immutable
class DeleteMedicationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteMedicationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMedicationVariables otherTyped = other as DeleteMedicationVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteMedicationVariables({
    required this.id,
  });
}

