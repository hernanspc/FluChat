import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theStreamApiKey =
      dotenv.env['API_KEY_STREAM'] ?? 'No hay api key';
}
