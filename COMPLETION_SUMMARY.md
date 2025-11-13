## Part 6 — Data Privacy

### Summary of Changes

- **Firebase Service (`lib/services/firebase_service.dart`):**
  - Added `TODO` comments to various methods to indicate where backend implementation for data privacy and access control is required. These comments serve as a guide for future Firebase integration to ensure:
    - Global uniqueness checking for usernames (`signUpWithEmail`).
    - Secure storage of parent-child relationships and proper access control for user profiles (`createUserProfile`, `getUserProfile`).
    - Correct association of `kidID` and `parentID` for tasks and enforcement of access control for task creation, updates, and deletions (`createTask`, `updateTask`, `deleteTask`).
    - Filtering of tasks by `kidID` and `parentID` for respective streams (`getTasksStream`, `getParentTasksStream`).
    - Verification of `taskId` ownership and parent-child linkage for proof uploads, task approvals, and rejections (`uploadTaskProof`, `approveTask`, `rejectTask`).
    - Secure establishment and breaking of parent-child links (`linkChildToParent`, `unlinkChildFromParent`).
    - Controlled access to child usernames and parent's children lists (`getChildIdByUsername`, `getParentChildrenStream`).

### Next Steps

- Implement the stubbed methods in `lib/services/firebase_service.dart` with actual Firebase functionality, paying close attention to the `TODO` comments regarding data privacy and access control. This will involve setting up Firestore security rules and implementing server-side logic to enforce these privacy requirements.