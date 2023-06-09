part of 'news_bloc_bloc.dart';

@immutable
class NewsBlocState {}

class NewsBlocInitialState extends NewsBlocState {}

class LoadedInitialNewsState extends NewsBlocState {
  final InitialNews initNews;
  LoadedInitialNewsState(this.initNews);
}

// class RefreshingState extends NewsBlocState {
//   final InitialNews initNews;
//   RefreshingState(this.initNews);
// }

class LoadingErrorState extends NewsBlocState {
  final DataErrorHelper error;
  LoadingErrorState(this.error);
}
