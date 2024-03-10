// Dio는 여러가지 기능 제공

import 'package:authentication/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage
  });

  // 1) 요청을 보낼 때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    if(options.headers['accessToken'] == 'true'){
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }

    if(options.headers['refreshToken'] == 'true'){
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }

    // super.onRequest(options, handler); 이거 반환값이 void여서 가능
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }
  
  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 없으면
    // 에러를 던진다
    if(refreshToken == null){
      // 에러를 던질 때는 handler.reject 사용
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh){
      final dio = Dio();

      try{
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization' : 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        //요청 옵션 가져오기
        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송 
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } catch(e){
        return handler.reject(err);
      } 
    }
    return handler.reject(err);
  }
  
}