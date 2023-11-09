import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/repository/local_storage_repository.dart';
import 'package:social_network/constants/constants.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        final userAcc = UserModel(
            email: user.email,
            username: null,
            fullName: user.displayName ?? '',
            avatar: user.photoUrl ?? '',
            bio: '',
            password: null,
            following: [],
            followers: [],
            id: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/users/signup'),
            body: userAcc.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
                username: jsonDecode(res.body)['user']['username'],
                avatar: jsonDecode(res.body)['user']['avatar'],
                id: jsonDecode(res.body)['user']['id'],
                token: jsonDecode(res.body)['token']);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> signInWithFacebook() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);

    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance
            .getUserData(fields: 'name,email,picture');

        final userAcc = UserModel(
            email: userData['email'],
            username: null,
            fullName: userData['name'] ?? '',
            avatar: userData['picture']['data']['url'] ?? '',
            bio: '',
            password: null,
            following: [],
            followers: [],
            id: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/users/signup'),
            body: userAcc.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
                username: jsonDecode(res.body)['user']['username'],
                avatar: jsonDecode(res.body)['user']['avatar'],
                id: jsonDecode(res.body)['user']['id'],
                token: jsonDecode(res.body)['token']);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> signInWithCredentials(
      String username, String password) async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);

    try {
      final userAcc = UserModel(
          email: '',
          username: username,
          fullName: '',
          avatar: '',
          bio: '',
          password: password,
          following: [],
          followers: [],
          id: '',
          token: '');

      var res = await _client.post(Uri.parse('$host/users/signin'),
          body: userAcc.toJson(),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      switch (res.statusCode) {
        case 200:
          final user = userAcc.copyWith(
              email: jsonDecode(res.body)['user']['email'],
              fullName: jsonDecode(res.body)['user']['fullName'],
              username: jsonDecode(res.body)['user']['username'],
              id: jsonDecode(res.body)['user']['id'],
              token: jsonDecode(res.body)['token']);

          error = ErrorModel(error: null, data: user);
          _localStorageRepository.setToken(user.token);
          break;
        case 404:
        case 500:
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
          break;
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> signUpWithCredentials(
      String email, String username, String fullName, String password) async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);

    try {
      final userAcc = UserModel(
          email: email,
          username: username,
          fullName: fullName,
          avatar: '',
          bio: '',
          password: password,
          following: [],
          followers: [],
          id: '',
          token: '');

      var res = await _client.post(Uri.parse('$host/users/signup'),
          body: userAcc.toJson(),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      switch (res.statusCode) {
        case 200:
          final newUser = userAcc.copyWith(
              id: jsonDecode(res.body)['user']['id'],
              token: jsonDecode(res.body)['token']);
          error = ErrorModel(error: null, data: newUser);
          _localStorageRepository.setToken(newUser.token);
          break;
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$host/users/getInfo'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });

        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<UserModel> getUserWithId(
      {required String token, required String userId}) async {
    var res =
        await _client.get(Uri.parse('$host/users/getInfo/$userId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
    UserModel? user;
    switch (res.statusCode) {
      case 200:
        user = UserModel.fromJson(
          jsonEncode(
            jsonDecode(res.body),
          ),
        );

        break;
    }
    return user!;
  }

  void signOut() async {
    // await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }

  void follow(String token, String id) async {
    await _client.post(Uri.parse('$host/users/follow'),
        body: jsonEncode({
          'followedId': id,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
  }

  void unfollow(String token, String id) async {
    await _client.post(Uri.parse('$host/users/unfollow'),
        body: jsonEncode({
          'followedId': id,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
  }

  Future<ErrorModel> getSuggestedUsers(String token) async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      final res =
          await _client.post(Uri.parse('$host/users/suggested'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      switch (res.statusCode) {
        case 200:
          List<UserModel> users = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            users.add(UserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
          error = ErrorModel(
            error: null,
            data: users,
          );
          break;
        default:
          error = ErrorModel(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<List<UserModel>> search(
      {required String token, required String username}) async {
    List<UserModel> users = [];

    try {
      final res = await _client
          .get(Uri.parse('$host/users/search?username=$username'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      switch (res.statusCode) {
        case 200:
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            users.add(UserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }

          break;
      }

      return users;
    } catch (e) {
      print(e);
      return users;
    }
  }
}
