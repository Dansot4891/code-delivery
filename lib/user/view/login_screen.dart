import 'dart:io';
import 'package:authentication/common/component/textformfield.dart';
import 'package:authentication/common/const/colors.dart';
import 'package:authentication/common/layout/default_layout.dart';
import 'package:authentication/user/model/user_model.dart';
import 'package:authentication/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {

    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Title(),
                const SizedBox(height: 16,),
                const _SubTitle(),
                Center(
                  child: Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 5 * 4,
                  ),
                ),
                CustomTextFormField(
                  hintText: "이메일을 입력해주세요.",
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16,),
                CustomTextFormField(
                  hintText: "비밀번호를 입력해주세요.",
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16,),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is UserModelLoading ? null : () async {
                      ref.read(userMeProvider.notifier).login(username: username, password: password);

                      //아이디:비밀번호
                      // final rawString = '$username:$password';
                      
                      // //base64로 변환하는 코드
                      // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                      
                      // String token = stringToBase64.encode(rawString);

                      // final resp = await dio.post('http://$ip/auth/login',
                      //   options: Options(
                      //     headers: {
                      //       'authorization' : 'Basic $token',
                      //     }
                      //   )
                      // );
                      
                      // final refreshToken = resp.data['refreshToken'];
                      // final accessToken = resp.data['accessToken'];

                      // final storage = ref.read(secureStorageProvider);

                      // await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                      // await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => RootTab())
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR
                    ),
                    child: Text('로그인', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: ()async{
                      
                    },
                    child: Text('회원가입', style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),);
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR
      ),
    );
  }
}