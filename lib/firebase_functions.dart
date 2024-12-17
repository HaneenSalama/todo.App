import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/user_model.dart';

class FirebaseFunctions {
  static CollectionReference<UserModel> getUsersCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: (docSnapshot, options) =>
                UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (userModel, options) => userModel.toJson(),
          );
  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      getUsersCollection().doc(userId).collection('tasks').withConverter(
            fromFirestore: (docSnapshot, options) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskModel, options) => taskModel.toJson(),
          );

  static Future<void> addTaskToFirestore(TaskModel task, String userId) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> doc = tasksCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(
      String taskId, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(taskId).delete();
  }

  static Future<UserModel> register({
    required name,
    required email,
    required password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel user = UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
    );
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    await usersCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentSnapshot<UserModel> docSnapshot =
        await usersCollection.doc(credential.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();

  static Future<void> updateTaskFromFirestore(
    String taskId,
    String userId,
    TaskModel task,
  ) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(taskId).update(task.toJson());
  }
}
