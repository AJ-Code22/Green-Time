library dataconnect_generated/generated.dart;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_new_shared_list.dart';

part 'get_shared_lists_for_child.dart';

part 'update_shared_list_item_is_completed.dart';

part 'delete_medication.dart';







class ExampleConnector {
  
  
  CreateNewSharedListVariablesBuilder createNewSharedList ({required String name, required Timestamp createdAt, }) {
    return CreateNewSharedListVariablesBuilder(dataConnect, name: name,createdAt: createdAt,);
  }
  
  
  GetSharedListsForChildVariablesBuilder getSharedListsForChild ({required String childId, }) {
    return GetSharedListsForChildVariablesBuilder(dataConnect, childId: childId,);
  }
  
  
  UpdateSharedListItemIsCompletedVariablesBuilder updateSharedListItemIsCompleted ({required String id, required bool isCompleted, }) {
    return UpdateSharedListItemIsCompletedVariablesBuilder(dataConnect, id: id,isCompleted: isCompleted,);
  }
  
  
  DeleteMedicationVariablesBuilder deleteMedication ({required String id, }) {
    return DeleteMedicationVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'hi',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

