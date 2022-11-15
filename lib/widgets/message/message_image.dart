import 'package:flutter/material.dart';

import '../custom_ui/full_photo.dart';

class MessageImage extends StatelessWidget {
  MessageImage(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Material(
        child: Image.network(
          content,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent loadingProgress,
          ) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffE8E8E8),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              width: 200,
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: const Color(0xfff5a623),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, object, stackTrace) {
            return Material(
              child: Image.asset(
                'assets/images/img_not_available.jpeg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
            );
          },
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.hardEdge,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhoto(
              url: content,
            ),
          ),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(0),
        ),
      ),
    );
  }
}
