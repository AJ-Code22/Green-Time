# dataconnect_generated/generated.dart SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetSharedListsForChild
#### Required Arguments
```dart
String childId = ...;
ExampleConnector.instance.getSharedListsForChild(
  childId: childId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetSharedListsForChildData, GetSharedListsForChildVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getSharedListsForChild(
  childId: childId,
);
GetSharedListsForChildData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String childId = ...;

final ref = ExampleConnector.instance.getSharedListsForChild(
  childId: childId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateNewSharedList
#### Required Arguments
```dart
String name = ...;
Timestamp createdAt = ...;
ExampleConnector.instance.createNewSharedList(
  name: name,
  createdAt: createdAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateNewSharedList, we created `CreateNewSharedListBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateNewSharedListVariablesBuilder {
  ...
 
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

  ...
}
ExampleConnector.instance.createNewSharedList(
  name: name,
  createdAt: createdAt,
)
.childId(childId)
.creatorId(creatorId)
.description(description)
.isPublic(isPublic)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateNewSharedListData, CreateNewSharedListVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createNewSharedList(
  name: name,
  createdAt: createdAt,
);
CreateNewSharedListData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
Timestamp createdAt = ...;

final ref = ExampleConnector.instance.createNewSharedList(
  name: name,
  createdAt: createdAt,
).ref();
ref.execute();
```


### UpdateSharedListItemIsCompleted
#### Required Arguments
```dart
String id = ...;
bool isCompleted = ...;
ExampleConnector.instance.updateSharedListItemIsCompleted(
  id: id,
  isCompleted: isCompleted,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateSharedListItemIsCompletedData, UpdateSharedListItemIsCompletedVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateSharedListItemIsCompleted(
  id: id,
  isCompleted: isCompleted,
);
UpdateSharedListItemIsCompletedData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isCompleted = ...;

final ref = ExampleConnector.instance.updateSharedListItemIsCompleted(
  id: id,
  isCompleted: isCompleted,
).ref();
ref.execute();
```


### DeleteMedication
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteMedication(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteMedicationData, DeleteMedicationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteMedication(
  id: id,
);
DeleteMedicationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteMedication(
  id: id,
).ref();
ref.execute();
```

