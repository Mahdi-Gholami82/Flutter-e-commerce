String? basicNoSpaceValidator(
  String? value, {
  required String fieldName,
  int minLenght = 0,
}) {
  assert(fieldName.trim().isNotEmpty);
  value = value?.trim() ?? "";
  if (value.isEmpty) {
    return "${fieldName.replaceFirst(fieldName[0], fieldName[0].toUpperCase())} cannot be empty";
  } else if (value.length < minLenght) {
    return "${fieldName[0].toUpperCase()}${fieldName.substring(1)} must exceed $minLenght characters";
  } else if (!RegExp(
    "^[\\p{L}\\p{Nd}]{$minLenght,}\$",
    unicode: true,
  ).hasMatch(value)) {
    return "Invalid $fieldName";
  }
  return null;
}
