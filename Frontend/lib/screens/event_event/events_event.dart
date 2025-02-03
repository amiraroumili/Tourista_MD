// event_event/events_event.dart
abstract class EventsEvent {}

class LoadEvents extends EventsEvent {}

class FilterEvents extends EventsEvent {
  final String year;
  final String month;
  final String day;

  FilterEvents({required this.year, required this.month, required this.day});
}
