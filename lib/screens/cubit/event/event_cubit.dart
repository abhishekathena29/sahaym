import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/model/event/event.dart';

import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final Repo repo;

  EventCubit(this.repo) : super(EventInitial());

  Future<void> loadEvents() async {
    emit(EventLoading());
    try {
      final events = await repo.getEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
