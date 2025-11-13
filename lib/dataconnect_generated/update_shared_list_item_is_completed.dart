part of 'example.dart';

class UpdateSharedListItemIsCompletedVariablesBuilder {
  String id;
  bool isCompleted;

  final FirebaseDataConnect _dataConnect;
  UpdateSharedListItemIsCompletedVariablesBuilder(this._dataConnect, {required  this.id,required  this.isCompleted,});
  Deserializer<UpdateSharedListItemIsCompletedData> dataDeserializer = (dynamic json)  => UpdateSharedListItemIsCompletedData.fromJson(jsonDecode(json));
  Serializer<UpdateSharedListItemIsCompletedVariables> varsSerializer = (UpdateSharedListItemIsCompletedVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateSharedListItemIsCompletedData, UpdateSharedListItemIsCompletedVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateSharedListItemIsCompletedData, UpdateSharedListItemIsCompletedVariables> ref() {
    UpdateSharedListItemIsCompletedVariables vars= UpdateSharedListItemIsCompletedVariables(id: id,isCompleted: isCompleted,);
    return _dataConnect.mutation("UpdateSharedListItemIsCompleted", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateSharedListItemIsCompletedSharedListItemUpdate {
  final String id;
  UpdateSharedListItemIsCompletedSharedListItemUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSharedListItemIsCompletedSharedListItemUpdate otherTyped = other as UpdateSharedListItemIsCompletedSharedListItemUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateSharedListItemIsCompletedSharedListItemUpdate({
    required this.id,
  });
}

@immutable
class UpdateSharedListItemIsCompletedData {
  final UpdateSharedListItemIsCompletedSharedListItemUpdate? sharedListItem_update;
  UpdateSharedListItemIsCompletedData.fromJson(dynamic json):
  
  sharedListItem_update = json['sharedListItem_update'] == null ? null : UpdateSharedListItemIsCompletedSharedListItemUpdate.fromJson(json['sharedListItem_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSharedListItemIsCompletedData otherTyped = other as UpdateSharedListItemIsCompletedData;
    return sharedListItem_update == otherTyped.sharedListItem_update;
    
  }
  @override
  int get hashCode => sharedListItem_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (sharedListItem_update != null) {
      json['sharedListItem_update'] = sharedListItem_update!.toJson();
    }
    return json;
  }

  UpdateSharedListItemIsCompletedData({
    this.sharedListItem_update,
  });
}

@immutable
class UpdateSharedListItemIsCompletedVariables {
  final String id;
  final bool isCompleted;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateSharedListItemIsCompletedVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  isCompleted = nativeFromJson<bool>(json['isCompleted']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSharedListItemIsCompletedVariables otherTyped = other as UpdateSharedListItemIsCompletedVariables;
    return id == otherTyped.id && 
    isCompleted == otherTyped.isCompleted;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, isCompleted.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['isCompleted'] = nativeToJson<bool>(isCompleted);
    return json;
  }

  UpdateSharedListItemIsCompletedVariables({
    required this.id,
    required this.isCompleted,
  });
}

