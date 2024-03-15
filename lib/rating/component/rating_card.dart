import 'package:authentication/common/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  // NetworkImage
  // AssetImage
  // CircleAvatar
  final ImageProvider avatarimage;
  // 리스트로 위젯 이미지를 보여줄 때
  final List<Image> images;
  // 별점
  final int rating;
  // 이메일
  final String email;
  // 리뷰 내용
  final String content;
  const RatingCard({
    required this.avatarimage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarimage: avatarimage,
          rating: rating,
          email: email,
        ),
        const SizedBox(
          height: 8,
        ),
        _Body(
          content: content,
        ),
        if(images.length > 0)
        SizedBox(
          height: 100,
          child: _Images(
            images: images,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarimage;
  final int rating;
  final String email;

  const _Header(
      {required this.avatarimage,
      required this.rating,
      required this.email,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundImage: avatarimage,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            email,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Flexible을 이용해야 텍스트가 화면을 넘어갔을 때 다음줄로 나오게 할 수 있음.
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;
  const _Images({
    required this.images,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding: EdgeInsets.only(right : index == images.length - 1 ? 0 : 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
