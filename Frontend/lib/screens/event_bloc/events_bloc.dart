// event_bloc/events_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event_event/events_event.dart';
import '../event_state/events_state.dart';
import '../event_info_new.dart';
import '../../database/database.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final DatabaseService dbService;

  EventsBloc({required this.dbService}) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<FilterEvents>(_onFilterEvents);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final eventsFromDb = await dbService.getAllEvents();
      emit(EventsLoaded(
          events:
              eventsFromDb.map((event) => EventInfo.fromMap(event)).toList()));
    } catch (e) {
      emit(EventsError(message: 'Error loading events: $e'));
    }
  }

  void _onFilterEvents(FilterEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final filteredEventsFromDb =
          await dbService.filterEvents(event.year, event.month, event.day);
      emit(EventsLoaded(
          events: filteredEventsFromDb
              .map((event) => EventInfo.fromMap(event))
              .toList()));
    } catch (e) {
      emit(EventsError(message: 'Error filtering events: $e'));
    }
  }
}
