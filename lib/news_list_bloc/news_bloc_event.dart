part of 'news_bloc_bloc.dart';

@immutable
abstract class NewsBlocEvent {}

class GetInitialNewEvent extends NewsBlocEvent {
  GetInitialNewEvent();
}

class RefreshEvent extends NewsBlocEvent {
  final InitialNews currentNews;
  final String key;
  final String refreshType;
  RefreshEvent(this.currentNews, this.key, this.refreshType);
}
