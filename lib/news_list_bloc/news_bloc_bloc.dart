import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/repository/repo.dart';

part 'news_bloc_event.dart';
part 'news_bloc_state.dart';

class NewsBlocBloc extends Bloc<NewsBlocEvent, NewsBlocState> {
  final Repository repository;
  NewsBlocBloc(this.repository) : super(NewsBlocInitialState()) {
    on<GetInitialNewEvent>(
      (event, emit) async {
        try {
          final initNews = await repository.initGet();
          emit(LoadedInitialNewsState(initNews));
        } catch (e) {
          emit(LoadingErrorState(e.toString()));
        }
      },
    );
    on<RefreshEvent>(
      (event, emit) async {
        emit(RefreshingState(event.currentNews));
        try {
          final initNews = await repository.refresh(event.currentNews, event.key, event.refreshType);
          emit(LoadedInitialNewsState(initNews));
        } catch (e) {
          emit(LoadingErrorState(e.toString()));
        }
      },
    );
  }
}
