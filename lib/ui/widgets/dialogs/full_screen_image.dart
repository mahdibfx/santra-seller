import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../buttons/rounded_icon_button.dart';

class FullScreenImage extends StatelessWidget {
  final String image;

  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image(
                  width: double.infinity,
                  image: CachedNetworkImageProvider(
                    image,
                  ),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: RoundedIconButton(
                      bgClr: Colors.white,
                      iconColor: Colors.black,
                      icon: UIDATAIcons.close,
                      onTap: () {
                        Get.back();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
