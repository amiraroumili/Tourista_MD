//event_event/event_information_event.dart
import '../event_info_new.dart';

abstract class EventInformationEvent {}

class LoadEventInformation extends EventInformationEvent {
  final EventInfo eventInfo;

  LoadEventInformation({required this.eventInfo});
}
