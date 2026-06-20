import 'dart:async';
import 'dart:developer';

import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:bridging_saathi/router/router.dart';
import 'package:bridging_saathi/screens/cubit/getToken/get_token_cubit.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthInterceptor implements Interceptor {
  final Prefs prefs;

  AuthInterceptor(this.prefs);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    Request request = chain.request;
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final apiToken = await prefs.getString(Prefs.apiToken);
        final updatedHeaders = request.headers;
        updatedHeaders['Connection'] = 'keep-alive';
        updatedHeaders['Keep-Alive'] = 'timeout=30, max=1000';
        updatedHeaders['Accept'] = 'application/json';
        updatedHeaders['Content-Type'] = 'application/json; charset=UTF-8';
        if (apiToken != null) {
          updatedHeaders['Authorization'] = 'Bearer $apiToken';
        }
        request = request.copyWith(headers: updatedHeaders);
        log(request.headers.toString());

        final response = await chain.proceed(request);

        if (response.statusCode == 401) {
          // log('AuthInterceptor: Unauthorized (401) - Clearing tokens');
          // await prefs.remove(Prefs.apiToken);
          final mobileNo = await prefs.getString(Prefs.userMobileNo);

          final context = router.routerDelegate.navigatorKey.currentContext!;
          if (context.mounted) {
            try {
              // Get new token
              final getTokenCubit = context.read<GetTokenCubit>();
              getTokenCubit.getToken(mobileNo ?? '');

              // Wait for token refresh to complete (with timeout)
              int attempts = 0;
              const maxAttempts = 3; // 1.5 seconds total wait time
              while (attempts < maxAttempts) {
                await Future.delayed(const Duration(milliseconds: 500));
                final newApiToken = await prefs.getString(Prefs.apiToken);

                if (newApiToken != null && newApiToken != apiToken) {
                  // Token has been refreshed, retry the original request
                  final retryHeaders =
                      Map<String, String>.from(request.headers);
                  retryHeaders['Authorization'] = 'Bearer $newApiToken';
                  final retryRequest = request.copyWith(headers: retryHeaders);
                  log('AuthInterceptor: Retrying request with new token');
                  return await chain.proceed(retryRequest);
                }
                attempts++;
              }

              log('AuthInterceptor: Token refresh timeout');
            } catch (e) {
              log('AuthInterceptor: Error during token refresh - $e');
            }
          }
          // router.go('/personalHealthForm');
          return response;
        }

        return response;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          log('AuthInterceptor: Max retries reached - $e');
          rethrow;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }

    throw Exception('Failed to complete request after $maxRetries attempts');
  }
}

// Optionally define a custom exception
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);

  @override
  String toString() {
    return 'AuthenticationException: $message';
  }
}
