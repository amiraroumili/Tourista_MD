// lib/event_state/event_information_state.dart
import 'package:equatable/equatable.dart';
import '../event_info_new.dart';

abstract class EventInformationState extends Equatable {
  const EventInformationState();

  @override
  List<Object> get props => [];
}

class EventInformationInitial extends EventInformationState {}

class EventInformationLoading extends EventInformationState {}

class EventInformationLoaded extends EventInformationState {
  final List<EventInfo> events;

  const EventInformationLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventInformationError extends EventInformationState {
  final String message;

  const EventInformationError({required this.message});

  @override
  List<Object> get props => [message];
}