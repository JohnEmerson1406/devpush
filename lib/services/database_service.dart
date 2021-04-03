import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Future writeStorageData(String key, String value) async {
  //   var writeData = await _storage.write(key: key, value: value);
  //   return writeData;
  // }

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(int id) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc('$id')
        .set({
          'id': id, // 79942716
          'level': 1,
          'devPoints': 0,
          'totalLogin': 0,
          'loginStreak': 0,
          'devMissions': []
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> getUser(int id) {
    return users.doc('$id').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
    // return users
    //     .where('id', isEqualTo: id)
    //     .get()
    //     .then((value) => print('value----->>>>>: ${value.docs[0].data()}'))
    //     .catchError((error) => print("ERRO AO DAR GET NO USER: $error"));
  }
}
