

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';

sealed class RegisterEvent {}

class RegisterSuccessEvent extends RegisterEvent {}

class RegisterErrorEvent extends RegisterEvent {
  final String message;
  final RegisterErrorType type;

  RegisterErrorEvent(this.message, this.type);
}// Assuming your events are here

class RegisterEventBus {
  // Use a StreamController to manage the flow of events
  // Use a broadcast stream so multiple widgets/subscribers can listen.
  final StreamController<RegisterEvent> _eventController =
      StreamController<RegisterEvent>.broadcast();

  // Expose the stream publicly for widgets to listen to
  Stream<RegisterEvent> get registerEvents => _eventController.stream;

  // Method to emit events
  void emitRegisterEvent(RegisterEvent event) {
    if (kDebugMode) {
      print('Emitting Register Event: $event');
    }
    _eventController.sink.add(event);
  }

  // Ensure the stream controller is closed when the service is disposed
  void dispose() {
    _eventController.close();
  }
}