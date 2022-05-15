import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    print('Called API: $path');
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<void> updateDoc({String path, Map<String, dynamic> data}) async {
    print('Called API: $path');
    final reference = Firestore.instance.document(path);
    await reference.updateData(data);
  }

  Future<void> updateArrayData(
      {String path, String field, dynamic value}) async {
    print('called API: $path');
    List<dynamic> list = [];
    list.add(value);
    final reference = Firestore.instance.document(path);
    await reference.updateData({field: FieldValue.arrayUnion(list)});
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    print('Called API: $path');
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data));
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    print('Called API: $path');
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) =>
          snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
    );
  }

  Stream<List<T>> ordereCollectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
    @required String orderBy,
    @required bool descending,
  }) {
    print('Called API: $path');
    final reference = Firestore.instance.collection(path).orderBy(
          orderBy,
          descending: descending,
        );
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) =>
          snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
    );
  }

  Stream<List<T>> collectionStreamConditionally<T>(
      {@required String path,
      @required T builder(Map<String, dynamic> data),
      @required String field,
      @required dynamic value}) {
    print('Called API: $path');
    final reference = Firestore.instance
        .collection(path)
        .where(field, isGreaterThan: value)
        .where('showToAll', isEqualTo: true)
        .orderBy(field, descending: false);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) =>
          snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
    );
  }
}
