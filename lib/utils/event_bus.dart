import 'dart:async';

// Event bus to fire and listen to the events
class EventBus {
  final _controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _controller.stream;

  void fire(dynamic event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

final eventBus = EventBus();
