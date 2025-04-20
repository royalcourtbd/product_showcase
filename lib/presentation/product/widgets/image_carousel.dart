import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/core/config/app_screen.dart';
import 'package:initial_project/core/utility/utility.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final int page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> uniqueImages = widget.images.toSet().toList();

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: uniqueImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, uniqueImages, index),
                child: Hero(
                  tag: 'product_image_${uniqueImages[index]}',
                  child: CachedNetworkImage(
                    imageUrl: uniqueImages[index],
                    fit: BoxFit.contain,
                    errorWidget:
                        (context, error, stackTrace) => Container(
                          color: context.color.blackColor100,
                          child: Icon(
                            Icons.image_not_supported,
                            color: context.color.blackColor300,
                            size: fiftyPx,
                          ),
                        ),
                  ),
                ),
              );
            },
          ),
        ),

        if (uniqueImages.length > 1)
          Positioned(
            bottom: tenPx,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                uniqueImages.length,
                (index) => Container(
                  width: eightPx,
                  height: eightPx,
                  margin: EdgeInsets.symmetric(horizontal: threePx),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? context.color.primaryColor
                            : context.color.blackColor300.withOpacityInt(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFullScreenImage(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FullScreenImageViewer(
              images: images,
              initialIndex: initialIndex,
            ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Image ${_currentIndex + 1}/${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: 'product_image_${widget.images[index]}',
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.black,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
