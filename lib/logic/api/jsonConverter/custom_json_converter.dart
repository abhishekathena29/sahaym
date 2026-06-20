import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:bridging_saathi/logic/model/patient/patient.dart';

class CustomJsonConverter extends JsonConverter {
  const CustomJsonConverter();

  @override
  Request convertRequest(Request request) {
    final req = super.convertRequest(request);
    return req.copyWith(body: req.body);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
      Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;

    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }
    try {
      final dynamic jsonMap = json.decode(body);

      if (jsonMap is List && BodyType == List<Patient>) {
        final list = jsonMap.map((item) => Patient.fromJson(item)).toList();
        return response.copyWith<BodyType>(body: list as BodyType);
      } else if (BodyType == Patient) {
        final converted = Patient.fromJson(jsonMap);
        return response.copyWith<BodyType>(body: converted as BodyType);
      }

      return response.copyWith<BodyType>(body: jsonMap as BodyType);
    } catch (e) {
      chopperLogger.warning(e);
      return response.copyWith<BodyType>(body: body as BodyType);
    }
  }
}
