import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRouteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _userId => _auth.currentUser?.uid;

  static Future<void> addFavorite(String routeId) async {
    final userId = _userId;

    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    await _firestore.collection('users').doc(userId).set({
      'favoriteRoutes': FieldValue.arrayUnion([routeId]),
    }, SetOptions(merge: true));
  }

  static Future<void> removeFavorite(String routeId) async {
    final userId = _userId;

    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    await _firestore.collection('users').doc(userId).set({
      'favoriteRoutes': FieldValue.arrayRemove([routeId]),
    }, SetOptions(merge: true));
  }

  static Future<Set<String>> getFavoriteRouteIds() async {
    final userId = _userId;

    if (userId == null) {
      return {};
    }

    final document = await _firestore.collection('users').doc(userId).get();

    final data = document.data();

    if (data == null) {
      return {};
    }

    final favorites = data['favoriteRoutes'];

    if (favorites is! List) {
      return {};
    }

    return favorites.whereType<String>().toSet();
  }

  static Future<bool> isFavorite(String routeId) async {
    final favorites = await getFavoriteRouteIds();

    return favorites.contains(routeId);
  }

  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
  getFavoriteRoutes() async {
    final userId = _userId;

    if (userId == null) {
      return [];
    }

    final userDocument = await _firestore.collection('users').doc(userId).get();

    final userData = userDocument.data();

    if (userData == null) {
      return [];
    }

    final favorites = userData['favoriteRoutes'];

    if (favorites is! List || favorites.isEmpty) {
      return [];
    }

    final routeIds = favorites.whereType<String>().toList();

    final routes = await Future.wait(
      routeIds.map(
        (routeId) => _firestore.collection('routes').doc(routeId).get(),
      ),
    );

    return routes.where((route) => route.exists).toList();
  }
}
