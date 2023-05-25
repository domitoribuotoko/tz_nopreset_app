import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/repository/repo.dart';

part 'news_details_bloc_event.dart';
part 'news_details_bloc_state.dart';

class NewsDetailsBlocBloc extends Bloc<NewsDetailsBlocEvent, NewsDetailsBlocState> {
  final Repository repository;
  NewsDetailsBlocBloc(this.repository) : super(NewsDetailsBlocInitial()) {
    on<GetNewsDetailesEvent>(
      (event, emit) async {
        try {
          final newsDeatailes = await repository.getNewsDetailes(event.id);
          emit(LoadedNewsDetailesState(newsDeatailes));
        } catch (e) {
          emit(LoadingErrorState(e.toString()));
        }
      },
    );
  }
}
