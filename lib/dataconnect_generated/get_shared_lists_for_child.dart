part of 'generated.dart';

class GetSharedListsForChildVariablesBuilder {
  String childId;

  final FirebaseDataConnect _dataConnect;
  GetSharedListsForChildVariablesBuilder(this._dataConnect, {required  this.childId,});
  Deserializer<GetSharedListsForChildData> dataDeserializer = (dynamic json)  => GetSharedListsForChildData.fromJson(jsonDecode(json));
  Serializer<GetSharedListsForChildVariables> varsSerializer = (GetSharedListsForChildVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetSharedListsForChildData, GetSharedListsForChildVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetSharedListsForChildData, GetSharedListsForChildVariables> ref() {
    GetSharedListsForChildVariables vars= GetSharedListsForChildVariables(childId: childId,);
    return _dataConnect.query("GetSharedListsForChild", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetSharedListsForChildSharedLists {
  final String id;
  final String name;
  final String? description;
  final bool? isPublic;
  final Timestamp createdAt;
  GetSharedListsForChildSharedLists.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  isPublic = json['isPublic'] == null ? null : nativeFromJson<bool>(json['isPublic']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSharedListsForChildSharedLists otherTyped = other as GetSharedListsForChildSharedLists;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    isPublic == otherTyped.isPublic && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, isPublic.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    if (isPublic != null) {
      json['isPublic'] = nativeToJson<bool?>(isPublic);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetSharedListsForChildSharedLists({
    required this.id,
    required this.name,
    this.description,
    this.isPublic,
    required this.createdAt,
  });
}

@immutable
class GetSharedListsForChildData {
  final List<GetSharedListsForChildSharedLists> sharedLists;
  GetSharedListsForChildData.fromJson(dynamic json):
  
  sharedLists = (json['sharedLists'] as List<dynamic>)
        .map((e) => GetSharedListsForChildSharedLists.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSharedListsForChildData otherTyped = other as GetSharedListsForChildData;
    return sharedLists == otherTyped.sharedLists;
    
  }
  @override
  int get hashCode => sharedLists.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sharedLists'] = sharedLists.map((e) => e.toJson()).toList();
    return json;
  }

  GetSharedListsForChildData({
    required this.sharedLists,
  });
}

@immutable
class GetSharedListsForChildVariables {
  final String childId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetSharedListsForChildVariables.fromJson(Map<String, dynamic> json):
  
  childId = nativeFromJson<String>(json['childId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSharedListsForChildVariables otherTyped = other as GetSharedListsForChildVariables;
    return childId == otherTyped.childId;
    
  }
  @override
  int get hashCode => childId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['childId'] = nativeToJson<String>(childId);
    return json;
  }

  GetSharedListsForChildVariables({
    required this.childId,
  });
}

