import 'package:flutter_complete_guide/models/race.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
Future<String> getRaceTrack({required RaceTrack race}) async {
  final image =
      supabase.storage.from('tracks').getPublicUrl(race.name + '.png');
  return image;
}
