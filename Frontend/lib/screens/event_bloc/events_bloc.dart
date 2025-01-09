// lib/event_bloc/events_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event_event/events_event.dart';
import '../event_state/events_state.dart';
import '../../api/event_api.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventService _eventService;

  EventsBloc() : 
    _eventService = EventService(),
    super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<FilterEvents>(_onFilterEvents);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final events = await _eventService.getEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventsError(message: 'Error loading events: $e'));
    }
  }

  void _onFilterEvents(FilterEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final filteredEvents = await _eventService.filterEvents(
        event.year, 
        event.month, 
        event.day
      );
      emit(EventsLoaded(events: filteredEvents));
    } catch (e) {
      emit(EventsError(message: 'Error filtering events: $e'));
    }
  }
}