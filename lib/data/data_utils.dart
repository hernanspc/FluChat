import 'dart:math';

abstract class DataUtils {
  static String getUserImage(String username) {
    if (username == 'hernandeveloper') {
      return 'https://scontent-lim1-1.xx.fbcdn.net/v/t39.30808-6/293769539_113865834719688_810065015384316511_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=1VbyR_hBQ2AAX8SXupn&_nc_ht=scontent-lim1-1.xx&oh=00_AfCt4NLn5nkOHwGwQjgi878cec-mcJiGj8R7FT3qDNcRtg&oe=649279D8';
    }
    return _getImageUrl(username);
  }

  static String getChannelImage() => _getImageUrl('');

  static String _getImageUrl(String value) {
    final random = Random();
    final randomNumber = random.nextInt(16777215);
    final randomHex = randomNumber.toRadixString(16).padLeft(6, '0');
    final imageUrl =
        'http://ui-avatars.com/api/?name=$value&background=$randomHex';
    return imageUrl;
  }
}
