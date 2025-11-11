part of 'generated.dart';

class CreateNewSharedListVariablesBuilder {
  Optional<String> _childId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _creatorId = Optional.optional(nativeFromJson, nativeToJson);
  String name;
  Optional<String> _description = Optional.optional(nativeFromJson, nativeToJson);
  Optional<bool> _isPublic = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreateNewSharedListVariablesBuilder childId(String? t) {
   _childId.value = t;
   return this;
  }
  CreateNewSharedListVariablesBuilder creatorId(String? t) {
   _creatorId.value = t;
   return this;
  }
  CreateNewSharedListVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  CreateNewSharedListVariablesBuilder isPublic(bool? t) {
   _isPublic.value = t;
   return this;
  }

  CreateNewSharedListVariablesBuilder(this._dataConnect, {required  this.name,});
  Deserializer<CreateNewSharedListData> dataDeserializer = (dynamic json)  => CreateNewSharedListData.fromJson(jsonDecode(json));
  Serializer<CreateNewSharedListVariables> varsSerializer = (CreateNewSharedListVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateNewSharedListData, CreateNewSharedListVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateNewSharedListData, CreateNewSharedListVariables> ref() {
    CreateNewSharedListVariables vars= CreateNewSharedListVariables(childId: _childId,creatorId: _creatorId,name: name,description: _description,isPublic: _isPublic,);
    return _dataConnect.mutation("CreateNewSharedList", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateNewSharedListSharedListInsert {
  final String id;
  CreateNewSharedListSharedListInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewSharedListSharedListInsert otherTyped = other as CreateNewSharedListSharedListInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateNewSharedListSharedListInsert({
    required this.id,
  });
}

@immutable
class CreateNewSharedListData {
  final CreateNewSharedListSharedListInsert sharedList_insert;
  CreateNewSharedListData.fromJson(dynamic json):
  
  sharedList_insert = CreateNewSharedListSharedListInsert.fromJson(json['sharedList_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewSharedListData otherTyped = other as CreateNewSharedListData;
    return sharedList_insert == otherTyped.sharedList_insert;
    
  }
  @override
  int get hashCode => sharedList_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sharedList_insert'] = sharedList_insert.toJson();
    return json;
  }

  CreateNewSharedListData({
    required this.sharedList_insert,
  });
}

@immutable
class CreateNewSharedListVariables {
  late final Optional<String>childId;
  late final Optional<String>creatorId;
  final String name;
  late final Optional<String>description;
  late final Optional<bool>isPublic;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateNewSharedListVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']) {
  
  
    childId = Optional.optional(nativeFromJson, nativeToJson);
    childId.value = json['childId'] == null ? null : nativeFromJson<String>(json['childId']);
  
  
    creatorId = Optional.optional(nativeFromJson, nativeToJson);
    creatorId.value = json['creatorId'] == null ? null : nativeFromJson<String>(json['creatorId']);
  
  
  
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  
  
    isPublic = Optional.optional(nativeFromJson, nativeToJson);
    isPublic.value = json['isPublic'] == null ? null : nativeFromJson<bool>(json['isPublic']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewSharedListVariables otherTyped = other as CreateNewSharedListVariables;
    return childId == otherTyped.childId && 
    creatorId == otherTyped.creatorId && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    isPublic == otherTyped.isPublic;
    
  }
  @override
  int get hashCode => Object.hashAll([childId.hashCode, creatorId.hashCode, name.hashCode, description.hashCode, isPublic.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(childId.state == OptionalState.set) {
      json['childId'] = childId.toJson();
    }
    if(creatorId.state == OptionalState.set) {
      json['creatorId'] = creatorId.toJson();
    }
    json['name'] = nativeToJson<String>(name);
    if(description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    if(isPublic.state == OptionalState.set) {
      json['isPublic'] = isPublic.toJson();
    }
    return json;
  }

  CreateNewSharedListVariables({
    required this.childId,
    required this.creatorId,
    required this.name,
    required this.description,
    required this.isPublic,
  });
}

