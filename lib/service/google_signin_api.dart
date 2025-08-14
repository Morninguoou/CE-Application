import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '112402731598-ih4f8pboggm1pb0scecm2bme1j339sk9.apps.googleusercontent.com',
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      await _googleSignIn.signOut(); // Optional: sign out first
      final user = await _googleSignIn.signIn();

      if (user == null) {
        print("Sign-in canceled by user.");
        return null;
      }

      // final auth = await user.authentication;
      // debugPrint("ID Token: ${auth.idToken}");
      // print("Access Token: ${auth.accessToken}");
      print("User Info: $user");

      return user;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
