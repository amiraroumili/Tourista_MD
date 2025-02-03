// event_state/events_state.dart
import '../event_info_new.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventInfo> events;

  EventsLoaded({required this.events});
}

class EventsError extends EventsState {
  final String message;

  EventsError({required this.message});
}
