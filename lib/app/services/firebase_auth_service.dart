import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Wraps Firebase Auth interactions.
/// All public methods throw [FirebaseAuthException] with
/// Indonesian [message] on error — callers just catch and show `e.message`.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Converts a plain username to the internal Firebase email format.
  String toFirebaseEmail(String username) =>
      '${username.toLowerCase()}@soybeanyield.com';

  String _mapError(String code) {
    const messages = {
      'user-not-found': 'Username tidak ditemukan',
      'wrong-password': 'Password salah',
      'invalid-credential': 'Username atau password salah',
      'invalid-email': 'Username atau password salah',
      'user-disabled': 'Akun ini dinonaktifkan',
      'email-already-in-use': 'Username sudah digunakan',
      'weak-password': 'Password minimal 6 karakter',
      'network-request-failed': 'Periksa koneksi internet Anda',
      'too-many-requests': 'Terlalu banyak percobaan. Coba lagi nanti',
    };
    return messages[code] ?? 'Terjadi kesalahan, silakan coba lagi';
  }

  // ── Auth accessors ────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign In ───────────────────────────────────────────────────────────────

  /// Signs in using [username] by converting to internal email format.
  Future<UserCredential?> signIn(String username, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: toFirebaseEmail(username),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _mapError(e.code),
      );
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async => _auth.signOut();

  // ── Create User ───────────────────────────────────────────────────────────

  /// Creates a new Firebase Auth account using a secondary app instance
  /// so the currently logged-in admin session is NOT interrupted.
  ///
  /// Returns the new user's UID on success, throws [FirebaseAuthException]
  /// with a localised Indonesian message on failure.
  Future<String?> createUser(String username, String password) async {
    FirebaseApp? secondaryApp;
    try {
      // Use a uniquely named app instance to isolate the sign-up call
      secondaryApp = await Firebase.initializeApp(
        name: 'create_user_${DateTime.now().millisecondsSinceEpoch}',
        options: Firebase.app().options,
      );
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: toFirebaseEmail(username),
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _mapError(e.code),
      );
    } finally {
      // Always clean up the temporary app instance
      await secondaryApp?.delete();
    }
  }

  // ── Delete (client-side limitation) ──────────────────────────────────────

  // Deleting another user's Firebase Auth account from the client side
  // requires the Firebase Admin SDK (server-side only).
  // The current approach deletes only the Firestore document — the Auth
  // account is preserved (can be cleaned up via Firebase Console or a
  // Cloud Function). See FirestoreUserService.deleteUserDoc().
}
