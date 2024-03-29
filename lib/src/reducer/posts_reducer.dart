import 'package:built_collection/built_collection.dart';
import 'package:instagram_clone/src/actions/posts/index.dart';
import 'package:instagram_clone/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<PostsState> postsReducer = combineReducers(<Reducer<PostsState>>[
  TypedReducer<PostsState, UpdatePostInfo>(_updatePostInfo),
  TypedReducer<PostsState, ListenForPostsSuccessful>(_listenForPostsSuccessful),
  TypedReducer<PostsState, CreatePostSuccessful>(_createPostSuccessful),
]);

PostsState _updatePostInfo(PostsState state, UpdatePostInfo action) {
  return state.rebuild((PostsStateBuilder b) {
    if (action.addImage != null) {
      b.info.paths.add(action.addImage);
    } else if (action.removeImage != null) {
      b.info.paths.remove(action.removeImage);
    } else if (action.description != null) {
      final List<String> tags =
          RegExp('\#([a-zA-Z0-9]+)').allMatches(action.description).map((RegExpMatch match) => match.group(1)).toList();

      b.info
        ..description = action.description
        ..tags = ListBuilder<String>(tags);
    } else if (action.addUser != null) {
      b.info.users.add(action.addUser);
    } else if (action.removeUser != null) {
      b.info.users.remove(action.removeUser);
    } else if (action.lat != null && action.lng != null) {
      b.info
        ..lat = action.lat
        ..lng = action.lng;
    } else {
      b.info = PostInfo().toBuilder();
    }
  });
}

PostsState _listenForPostsSuccessful(PostsState state, ListenForPostsSuccessful action) {
  return state.rebuild((PostsStateBuilder b) {
    b.posts = ListBuilder<Post>(action.posts);
  });
}

PostsState _createPostSuccessful(PostsState state, CreatePostSuccessful action) {
  return state.rebuild((PostsStateBuilder b) {
    b.info = PostInfo().toBuilder();
  });
}
