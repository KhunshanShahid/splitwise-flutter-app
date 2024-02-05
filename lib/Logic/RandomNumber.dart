import 'dart:math';

class hooksFunction {

String generateRandomNumber() {
  final random = Random();
  String randomNumber = '';
  
  for (int i = 0; i < 6; i++) {
    randomNumber += random.nextInt(10).toString();
  }
  return randomNumber;
}
}