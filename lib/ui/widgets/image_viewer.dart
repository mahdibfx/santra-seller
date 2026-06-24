import 'package:flutter/material.dart';

import '../common/app_text_styles.dart';
import 'app_icon.dart';
import 'thumb_image.dart';

/// Full-screen reference-photo viewer with paging, counter, and thumbnails.
Future<void> showImageViewer(BuildContext context, List<String> images, int index) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: const Color(0xF5081818),
      pageBuilder: (_, __, ___) => _ImageViewer(images: images, initialIndex: index),
    ),
  );
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_index + 1} / ${widget.images.length}',
                        style: AppTextStyles.body(context, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), shape: BoxShape.circle),
                        child: const Center(child: AppIcon('x', size: 22, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.images.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ThumbImage(path: widget.images[i], size: 320, radius: 20),
                    ),
                  ),
                ),
              ),
              if (widget.images.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < widget.images.length; i++)
                        GestureDetector(
                          onTap: () => _controller.animateToPage(i,
                              duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: i == _index ? Colors.white : Colors.transparent, width: 2),
                            ),
                            child: Opacity(
                              opacity: i == _index ? 1 : 0.45,
                              child: ThumbImage(path: widget.images[i], size: 48, radius: 9),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
