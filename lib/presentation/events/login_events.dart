
import 'dart:async';

import 'package:flutter/foundation.dart';

sealed class LoginEvent {}

class LoginSuccessEvent extends LoginEvent {}

class LoginErrorEvent extends LoginEvent {
  final String message;

  LoginErrorEvent(this.message);
}


mixin LoginEventNotifier on ChangeNotifier {
  // Use a StreamController to manage the flow of events
  // IMPORTANT: Use a broadcast stream so multiple widgets/subscribers can listen.
  final StreamController<LoginEvent> _eventController =
  StreamController<LoginEvent>.broadcast();

  // Expose the stream publicly for widgets to listen to
  Stream<LoginEvent> get loginEvents => _eventController.stream;

  // Method to emit events
  void emitLoginEvent(LoginEvent event) {
    if (kDebugMode) {
      print('Emitting Login Event: $event');
    }
    // Add the event to the stream sink
    _eventController.sink.add(event);
  }

  // Ensure the stream controller is closed when the notifier is disposed
  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}