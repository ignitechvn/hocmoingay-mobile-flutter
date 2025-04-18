sealed class ViewEvent {
  const ViewEvent();
}

class NavigateTo extends ViewEvent {

  final String route;
  const NavigateTo(this.route);
}

class ShowMessage extends ViewEvent {
  final String message;
  const ShowMessage(this.message);
}

class BaseState {
  final bool isLoading;
  final ViewEvent? event;

  const BaseState({
    this.isLoading = false,
    this.event,
  });

  BaseState copyWith({
    bool? isLoading,
    ViewEvent? event,
  }) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      event: event,
    );
  }
}
