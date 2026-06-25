import 'dart:convert';

import 'package:dio/dio.dart';

class GoogleSheetService {

static const String scriptUrl =
'https://script.google.com/macros/s/AKfycbzkOiW-YBAyGMk2wKzgX0lHMeTXqFjJeBCnJ26RtxYJwEcYQglxvd5k94hVghjbXVZ7Ng/exec';

final Dio dio = Dio();

Future<void> saveSurvey({
required Map<String, dynamic> farmer,
required List<Map<String, dynamic>> surveys,
}) async {


final payload = {
  "farmer": farmer,
  "surveys": surveys,
};

final encoded =
    Uri.encodeComponent(
      jsonEncode(payload),
    );

final response =
    await dio.get(
  "$scriptUrl?data=$encoded",
);

print(response.data);


}
}
