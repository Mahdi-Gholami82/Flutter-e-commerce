String? basicNoSpaceValidator(String? value, {required String fieldName}) {
  assert(fieldName.trim().isNotEmpty);
  value = value?.trim() ?? "";
  if (value.isEmpty) {
    return "${fieldName.replaceFirst(fieldName[0], fieldName[0].toUpperCase())} cannot be empty";
  } else if (!RegExp(r"^\w+$").hasMatch(value)) {
    return "Invalid $fieldName";
  }
  return null;
}
