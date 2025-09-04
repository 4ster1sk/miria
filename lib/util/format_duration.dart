String formatDuration(Duration duration, {required Duration reference}) {
  // ignore: parameter_assignments
  duration = duration.abs();
  // ignore: parameter_assignments
  reference = reference.abs();

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return (duration.inHours > 0 || reference.inHours > 0)
      ? "$hours:$minutes:$seconds"
      : "$minutes:$seconds";
}
