abstract class AlertsState {
  const AlertsState();
}

class AlertsInitial extends AlertsState {
  const AlertsInitial();
}

class AlertsLoading extends AlertsState {
  const AlertsLoading();
}

class AlertsLoaded extends AlertsState {
  const AlertsLoaded();
}

class AlertsError extends AlertsState {
  final String message;
  const AlertsError(this.message);
}
