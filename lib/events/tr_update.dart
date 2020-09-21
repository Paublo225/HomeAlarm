import 'package:homealarm/model/trigger.dart';

import 'tr_event.dart';

class UpdateTrigger extends TriggerEvent {
  Trigger newTr;
  int trIndex;

  UpdateTrigger(int index, Trigger tr) {
    newTr = tr;
    trIndex = index;
  }
}
