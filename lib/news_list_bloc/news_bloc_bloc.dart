import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/repository/repo.dart';

part 'news_bloc_event.dart';
part 'news_bloc_state.dart';

class NewsBlocBloc extends Bloc<NewsBlocEvent, NewsBlocState> {
  final Repository repository;

  NewsBlocBloc(this.repository) : super(NewsBlocInitialState()) {
    on<GetInitialNewsEvent>(
      (event, emit) async {
        final data = await repository.initGet();
        if (data is DataErrorHelper) {
          emit(LoadingErrorState(data));
        } else {
          emit(LoadedInitialNewsState(data));
        }
      },
    );
    on<RefreshEvent>(
      (event, emit) async {
        final data = await repository.refresh(event.currentNews, event.key, event.refreshType);
        if (data is DataErrorHelper) {
          emit(LoadingErrorState(data));
        } else {
          emit(LoadedInitialNewsState(data));
        }
      },
    );
  }

  void getInitialNews() => add(
        GetInitialNewsEvent(),
      );

  void refreshNews(final InitialNews currentNews, final String key, final String refreshType) => add(
        RefreshEvent(currentNews, key, refreshType),
      );

  // Stream<NewsBlocState> mapEventToState(NewsBlocEvent event) async* {
  //   if (event is GetInitialNewsEvent) {
  //     yield* _getInitialNews();
  //   }
  // }

  // Stream<NewsBlocState> _getInitialNews() async* {
  //   final data = await repository.initGet();
  //   if (data is DataErrorHelper) {
  //     yield LoadingErrorState(data);
  //     // if (data.noConnection) {
  //     //   yield ErrorNoConnectionState();
  //     // } else {
  //     //   yield ErrorLoadingState(data);
  //     // }
  //   } else {
  //     yield LoadedInitialNewsState(data);
  //   }
  // }
}
