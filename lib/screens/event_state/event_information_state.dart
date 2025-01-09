//event_state/event_information_state.dart
import '../event_info_new.dart';

abstract class EventInformationState {}

class EventInformationInitial extends EventInformationState {}

class EventInformationLoading extends EventInformationState {}

class EventInformationLoaded extends EventInformationState {
  final List<EventInfo> events;

  EventInformationLoaded({required this.events});
}

class EventInformationError extends EventInformationState {
  final String message;

  EventInformationError({required this.message});
}