import 'package:homealarm/model/trigger.dart';

import '../app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tr_event.dart';

class AddTrigger extends TriggerEvent {
  Trigger newTrigger;

  AddTrigger(Trigger tr) {
    newTrigger = tr;
  }
}
