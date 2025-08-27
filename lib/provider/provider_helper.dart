import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:lost_found/screens/reset_password.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderHelper extends ChangeNotifier {
  var supabase = Supabase.instance.client;
  User? _user;
  User? get user => _user;

  Future<void> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw Exception("Sign up failed. Please try again.");
      }

      _user = response.user;
      notifyListeners();
    } on AuthException catch (e) {
      // Supabase specific errors
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  //login
  Future<void> login(String email, String pass) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        password: pass,
        email: email,
      );

      if (response.user == null) {
        throw Exception("Login failed. Please try again.");
      }

      _user = response.user;
      notifyListeners();
    } on AuthException catch (e) {
      // Supabase specific errors
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  //reset mail
  Future<void> resetMail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'lostfound://reset-password',
      );

      notifyListeners();
    } on AuthException catch (e) {
      // Supabase specific errors
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  //reset pass

  Future<void> resetPass(String password) async {
    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(password: password),
      );
      if (response.user == null) {
        throw Exception("reset failed. Please try again.");
      }

      _user = response.user;
      notifyListeners();
    } on AuthException catch (e) {
      // Supabase specific errors
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

//delete post
  Future<void> deletePost(String id) async {
    try {
      await supabase.from('lost_found').delete().eq('id', id);

      notifyListeners();
    } on AuthException catch (e) {
      // Supabase specific errors
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
