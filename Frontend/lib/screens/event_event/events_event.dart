// lib/event_event/events_event.dart
import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventsEvent {}

class FilterEvents extends EventsEvent {
  final String year;
  final String month;
  final String day;

  const FilterEvents({
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  List<Object> get props => [year, month, day];
}