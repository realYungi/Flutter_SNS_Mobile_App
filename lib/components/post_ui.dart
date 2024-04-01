import 'package:flutter/material.dart';

class PostUI extends StatelessWidget {
  const PostUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '11:20',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(Icons.more_vert),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'おすすめ！',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '新生活を過ごすこの頃、こんな日は！今日もいい天気。',
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '김태형 | 韓国外国語大学',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(width: 5),
                  Text('100'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}