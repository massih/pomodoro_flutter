
enum PomodoroSession {
  STUDY,
  BREAK
}

class PomodoroTimer {
  Duration elapsed;
  Duration remaining;
  PomodoroSession session;
  bool inProgress;

  PomodoroTimer(this.elapsed, this.remaining, this.session, this.inProgress);
}