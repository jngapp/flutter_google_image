library flutter_google_image;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';

class FlutterGoogleImage {
  int _offset = 0;
  final int _integral = 20;
  String? _url;

  FlutterGoogleImage._internal();

  static final FlutterGoogleImage _instance = FlutterGoogleImage._internal();

  factory FlutterGoogleImage() {
    return _instance;
  }

  Future<List<String>> searchImage(String keyword) async {
    _offset = 0;
    _url = null;
    String encodedString = Uri.encodeComponent(keyword);
    final offsetStr = 'start=$_offset';
    _url = 'https://www.google.com/search?q=$encodedString&gbv=1&tbm=isch&$offsetStr';
    _offset += _integral;
    List<String> imageUrls = [];
    imageUrls = await browse(_url!);
    return imageUrls;
  }

  Future<List<String>> fetchNext() async {
    final offsetStr = 'start=$_offset';
    _url = '$_url&$offsetStr';
    _offset += _integral;
    List<String> imageUrls = [];
    imageUrls = await browse(_url!);
    return imageUrls;
  }

  Future<List<String>> browse(String url) async {
    List<String> imageUrls = [];
    final Completer<List<String>> completer = Completer<List<String>>();
    await executeUrl(url,
            (controller, url) async {
          String? html = await controller.getHtml();
          final doc = parse(html).body;
          final elements = doc?.getElementsByTagName('span div div div div a');
          for (final elem in elements!) {
            final googleUrl = Uri.parse('https://www.google.com/${elem.attributes['href']}');
            final imgUrl = googleUrl.queryParameters['imgurl'];
            if (imgUrl != null && imgUrl.contains('https')) {
              if(await isImageLink(imgUrl)) {
                imageUrls.add(imgUrl);
              }
              // imageUrls.add(imgUrl);
            }
          }
          return completer.complete(imageUrls);
        });
    imageUrls = await completer.future;
    return imageUrls;
  }

  Future<void> executeUrl(String url,
      Function(InAppWebViewController controller, WebUri? url) onLoadStop) async {
    HeadlessInAppWebView headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
          useOnLoadResource: false,
          cacheEnabled: false,
          // javaScriptEnabled: false,
          useShouldOverrideUrlLoading: false,
          // allowContentAccess: false,
          // allowsLinkPreview: false,
          // blockNetworkImage: true,
          safeBrowsingEnabled: false,
          userAgent: 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36'
      ),
      // onLoadStart: (controller, url) => print('onLoadStart: $url'),
      onLoadStop: onLoadStop,
    );
    await headlessWebView.run();
    // Future.delayed(const Duration(milliseconds: 2000), (){
    //   headlessWebView.dispose();
    // });
    // await headlessWebView.dispose();
  }

  Future<bool> isImageLink(String? url) async {
    //   if(url == null) {
    //     return false;
    //   }
    //   final response = await http.head(Uri.parse(url));
    //   return response.headers['content-type']?.startsWith('image/') ?? false;
    // }
    final regex = RegExp(r'[\w\-]+\.(jpg|png|jpeg)', caseSensitive: false);
    return regex.hasMatch(url ?? '');
  }
}
