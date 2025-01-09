import 'package:flutter_bloc/flutter_bloc.dart';
import '../event_event/event_information_event.dart';
import '../event_state/event_information_state.dart';
import '../../api/event_api.dart';

class EventInformationBloc extends Bloc<EventInformationEvent, EventInformationState> {
  final EventService _eventService;

  EventInformationBloc() : 
    _eventService = EventService(),
    super(EventInformationInitial()) {
    on<LoadEventInformation>(_onLoadEventInformation);
  }

  void _onLoadEventInformation(LoadEventInformation event, Emitter<EventInformationState> emit) async {
    emit(EventInformationLoading());
    try {
      final events = await _eventService.getEvents();
      emit(EventInformationLoaded(events: events));
    } catch (e) {
      emit(EventInformationError(message: 'Error loading event information: $e'));
    }
  }
}