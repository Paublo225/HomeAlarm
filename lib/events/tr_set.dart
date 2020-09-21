import 'package:homealarm/model/trigger.dart';

import 'tr_event.dart';

class SetTriggers extends TriggerEvent {
  List<Trigger> trList;

  SetTriggers(List<Trigger> triggers) {
    trList = triggers;
  }
}
