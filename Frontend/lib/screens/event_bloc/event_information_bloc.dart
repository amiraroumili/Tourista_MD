// event_bloc/event_information_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event_event/event_information_event.dart';
import '../event_state/event_information_state.dart';
import '../event_info_new.dart';
import '../../database/database.dart';

class EventInformationBloc extends Bloc<EventInformationEvent, EventInformationState> {
  final DatabaseService dbService;

  EventInformationBloc({required this.dbService}) : super(EventInformationInitial()) {
    on<LoadEventInformation>(_onLoadEventInformation);
  }

  void _onLoadEventInformation(LoadEventInformation event, Emitter<EventInformationState> emit) async {
    emit(EventInformationLoading());
    try {
      final eventsFromDb = await dbService.getAllEvents();
      emit(EventInformationLoaded(events: eventsFromDb.map((event) => EventInfo.fromMap(event)).toList()));
    } catch (e) {
      emit(EventInformationError(message: 'Error loading event information: $e'));
    }
  }
}