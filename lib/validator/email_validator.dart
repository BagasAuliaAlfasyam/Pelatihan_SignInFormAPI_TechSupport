String? validateEmail(String? value){
  if(value == null || value.isEmpty){
    return 'Email is Required';
  }

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  if (!emailRegex.hasMatch(value)){
    return 'Please enter a valid email address';
  }
  return null;
}