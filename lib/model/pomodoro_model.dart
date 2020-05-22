
enum PomodoroSession {
  STUDY,
  BREAK
}

class PomodoroModel {
  final Duration elapsed;
  final Duration remaining;
  final PomodoroSession session;
  final bool inProgress;

  PomodoroModel(this.elapsed, this.remaining, this.session, this.inProgress);
}