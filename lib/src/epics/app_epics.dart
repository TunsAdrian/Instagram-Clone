import 'package:instagram_clone/src/data/auth_api.dart';
import 'package:instagram_clone/src/data/posts_api.dart';
import 'package:instagram_clone/src/epics/auth_epics.dart';
import 'package:instagram_clone/src/epics/posts_epics.dart';
import 'package:instagram_clone/src/models/index.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';

class AppEpics {
  const AppEpics({@required AuthApi authApi, @required PostsApi postsApi})
      : assert(authApi != null),
        assert(postsApi != null),
        _authApi = authApi,
        _postsApi = postsApi;

  final AuthApi _authApi;
  final PostsApi _postsApi;

  Epic<AppState> get epics {
    return combineEpics<AppState>(<Epic<AppState>>[
      AuthEpics(api: _authApi).epics,
      PostsEpics(api: _postsApi).epics,
    ]);
  }
}
