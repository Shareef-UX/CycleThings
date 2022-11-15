import 'package:flutter/material.dart';

class LoadImage extends StatelessWidget {
  final String content;
  final double tinggi;
  final double lebar;

  LoadImage(this.content, this.tinggi, this.lebar);

  @override
  Widget build(BuildContext context) {
    return Material(
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
              width: lebar,
              height: tinggi,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
          );
        },
        width: lebar,
        height: tinggi,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      clipBehavior: Clip.hardEdge,
    );
  }
}
