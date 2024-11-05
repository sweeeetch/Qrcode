class AttendanceRecord {
  final String email;
  int presence;

  AttendanceRecord({
    required this.email,
    this.presence = 0,
  });
}