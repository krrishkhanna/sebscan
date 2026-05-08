import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/scan_result_model.dart';

class FirebaseService {
  FirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> saveScan(ScanResultModel result) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('scans').add(result.toJson(userId));
    } catch (error, stackTrace) {
      debugPrint('saveScan failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Stream<List<ScanResultModel>> getScans() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(const <ScanResultModel>[]);
    }

    try {
      return _firestore
          .collection('scans')
          .where('userId', isEqualTo: userId)
          .orderBy('scannedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ScanResultModel.fromJson(doc.data(), id: doc.id);
        }).toList();
      }).handleError((Object error, StackTrace stackTrace) {
        debugPrint('getScans stream failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      });
    } catch (error, stackTrace) {
      debugPrint('getScans setup failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return Stream.value(const <ScanResultModel>[]);
    }
  }

  Future<void> deleteScan(String id) async {
    try {
      await _firestore.collection('scans').doc(id).delete();
    } catch (error, stackTrace) {
      debugPrint('deleteScan failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _auth.signInAnonymously();
    } catch (error, stackTrace) {
      debugPrint('signOut failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
