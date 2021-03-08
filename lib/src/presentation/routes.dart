import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/src/presentation/home.dart';
import 'package:instagram_clone/src/presentation/posts/create_post.dart';
import 'package:instagram_clone/src/presentation/posts/post_details.dart';
import 'package:instagram_clone/src/presentation/signup/password_page.dart';
import 'package:instagram_clone/src/presentation/signup/signup_page.dart';
import 'package:instagram_clone/src/presentation/signup/username_page.dart';
import 'package:instagram_clone/src/presentation/widgets/search_users_page.dart';

import 'login/reset_password_page.dart';

// ignore: avoid_classes_with_only_static_members
class AppRoutes {
  static const String home = '/';
  static const String signup = '/signup';
  static const String username = '/username';
  static const String password = '/password';
  static const String resetPassword = '/resetPassword';
  static const String createPost = '/createPost';
  static const String postDetails = '/postDetails';
  static const String searchUsers = '/searchUsers';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    home: (BuildContext context) {
      return const Home();
    },
    signup: (BuildContext context) {
      return const SignupPage();
    },
    username: (BuildContext context) {
      return const UsernamePage();
    },
    password: (BuildContext context) {
      return const PasswordPage();
    },
    resetPassword: (BuildContext context) {
      return const ResetPasswordPage();
    },
    createPost: (BuildContext context) {
      return const CreatePost();
    },
    postDetails: (BuildContext context) {
      return const PostDetails();
    },
    searchUsers: (BuildContext context) {
      return const SearchUsersPage();
    },
  };
}
