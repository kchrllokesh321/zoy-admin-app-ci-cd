String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length == 1) {
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
  } else {
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
