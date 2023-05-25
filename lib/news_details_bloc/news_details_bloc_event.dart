part of 'news_details_bloc_bloc.dart';

@immutable
abstract class NewsDetailsBlocEvent {}

class GetNewsDetailesEvent extends NewsDetailsBlocEvent {
  final String id;
  GetNewsDetailesEvent(
    this.id,
  );
}
