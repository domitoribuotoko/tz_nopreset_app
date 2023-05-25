part of 'news_details_bloc_bloc.dart';

@immutable
abstract class NewsDetailsBlocState {}

class NewsDetailsBlocInitial extends NewsDetailsBlocState {}

class LoadedNewsDetailesState extends NewsDetailsBlocState {
  final Data newsDetailes;
  LoadedNewsDetailesState(this.newsDetailes);
}

class LoadingErrorState extends NewsDetailsBlocState {
  final String error;
  LoadingErrorState(this.error);
}
