
enum PomodoroSession {
  STUDY,
  BREAK
}

class PomodoroTimer {
  final Duration elapsed;
  final Duration remaining;
  final PomodoroSession session;
  final bool inProgress;

  PomodoroTimer(this.elapsed, this.remaining, this.session, this.inProgress);
}