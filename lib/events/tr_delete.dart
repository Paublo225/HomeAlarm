import 'tr_event.dart';

class DeleteTrigger extends TriggerEvent {
  int trIndex;

  DeleteTrigger(int index) {
    trIndex = index;
  }
}
