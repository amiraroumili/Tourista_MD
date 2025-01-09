// lib/event_event/event_information_event.dart
import 'package:equatable/equatable.dart';
import '../event_info_new.dart';

abstract class EventInformationEvent extends Equatable {
  const EventInformationEvent();

  @override
  List<Object> get props => [];
}

class LoadEventInformation extends EventInformationEvent {
  final EventInfo eventInfo;

  const LoadEventInformation({required this.eventInfo});

  @override
  List<Object> get props => [eventInfo];
}