import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseFirebaseUser {
  DatabaseFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

DatabaseFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<DatabaseFirebaseUser> databaseFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<DatabaseFirebaseUser>(
      (user) {
        currentUser = DatabaseFirebaseUser(user);
        return currentUser!;
      },
    );
