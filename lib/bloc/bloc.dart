import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homealarm/events/tr_add.dart';
import 'package:homealarm/events/tr_delete.dart';
import 'package:homealarm/events/tr_event.dart';
import 'package:homealarm/events/tr_set.dart';
import 'package:homealarm/events/tr_update.dart';
import 'package:homealarm/model/trigger.dart';

class TriggerBloc extends Bloc<TriggerEvent, List<Trigger>> {
  static List<Trigger> initialState = List<Trigger>();
  TriggerBloc() : super(initialState);

  @override
  Stream<List<Trigger>> mapEventToState(TriggerEvent event) async* {
    if (event is SetTriggers) {
      yield event.trList;
    } else if (event is AddTrigger) {
      List<Trigger> newState = List.from(state);
      if (event.newTrigger != null) {
        newState.add(event.newTrigger);
      }
      yield newState;
    } else if (event is DeleteTrigger) {
      List<Trigger> newState = List.from(state);
      newState.removeAt(event.trIndex);
      yield newState;
    } else if (event is UpdateTrigger) {
      List<Trigger> newState = List.from(state);
      newState[event.trIndex] = event.newTr;
      yield newState;
    }
  }
}
