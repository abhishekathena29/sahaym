// import 'dart:developer';
// import 'dart:io';

// import 'package:built_collection/built_collection.dart';
// import 'package:built_value/serializer.dart';
// import 'package:built_value/standard_json_plugin.dart';
// import 'package:chopper/chopper.dart';
// import 'package:purity_harvest/logic/model/response/serializers.dart';

// final jsonSerializers =
//     (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

// class BuiltValueConverter extends JsonConverter {
//   T? _deserialize<T>(dynamic value) {
//     final serializer = jsonSerializers.serializerForType(T) as Serializer<T>?;
//     if (serializer == null) {
//       throw Exception('No serializer for type $T');
//     }

//     return jsonSerializers.deserializeWith<T>(serializer, value);
//   }

//   BuiltList<T> _deserializeListOf<T>(Iterable value) => BuiltList(
//         value.map((value) => _deserialize<T>(value)).toList(growable: false),
//       );

//   dynamic _decode<T>(dynamic entity) {
//     /// handle case when we want to access to Map<String, dynamic> directly
//     /// getResource or getMapResource
//     /// Avoid dynamic or unconverted value, this could lead to several issues
//     if (entity is T) return entity;

//     try {
//       return entity is List
//           ? _deserializeListOf<T>(entity)
//           : _deserialize<T>(entity);
//     } catch (e) {
//       log(e.toString());

//       return null;
//     }
//   }

//   @override
//   Future<Response<ResultType>> convertResponse<ResultType, Item>(
//     Response response,
//   ) async {
//     try {
//       final Response jsonRes = await super.convertResponse(response);
//       final body = _decode<Item>(jsonRes.body);

//       if (body == null) {
//         log('BuiltValueConverter: Failed to decode response body');
//         throw Exception('Failed to decode response body');
//       }

//       return jsonRes.copyWith<ResultType>(body: body);
//     } catch (e) {
//       log('BuiltValueConverter Error: $e');
//       if (e is SocketException) {
//         throw Exception('Network connection error: ${e.message}');
//       }
//       rethrow;
//     }
//   }
// }
