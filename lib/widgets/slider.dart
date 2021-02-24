import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/networking/slider_helper.dart';

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SliderHelper sliderHelper = SliderHelper();

    return Container(
      height: MediaQuery.of(context).size.height *0.22,
      alignment: Alignment.center,
      child: FutureBuilder(
        future: sliderHelper.fetchSliders(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Swiper(
            itemCount: snapshot.data.length,
            autoplay: true,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: snapshot.data[index],
                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fadeInCurve: Curves.easeIn,
                fadeOutDuration: Duration(milliseconds: 1000),
                fit: BoxFit.cover,
              );
            },
            viewportFraction: 0.7,
            scale: 0.9,
          );
        }
      ),
    );
  }
}
