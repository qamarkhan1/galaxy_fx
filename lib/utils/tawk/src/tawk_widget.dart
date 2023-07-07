// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'tawk_visitor.dart';

/// [Tawk] Widget.
class Tawk extends StatefulWidget {
  /// Tawk direct chat link.
  final String directChatLink;

  /// Object used to set the visitor name and email.
  final TawkVisitor? visitor;

  /// Called right after the widget is rendered.
  final Function()? onLoad;

  /// Called when a link pressed.
  final Function(String url)? onLinkTap;

  /// Render your own loading widget.
  final Widget? placeholder;

  const Tawk({
    Key? key,
    required this.directChatLink,
    this.visitor,
    this.onLoad,
    this.onLinkTap,
    this.placeholder,
  }) : super(key: key);

  @override
  TawkState createState() => TawkState();
}

class TawkState extends State<Tawk> {
  WebViewController? _controller;
  bool _isLoading = true;

  void _setUser(TawkVisitor visitor) {
    final json = jsonEncode(visitor);
    String javascriptString;

    if (Platform.isIOS) {
      javascriptString = '''
        Tawk_API = Tawk_API || {};
        Tawk_API.setAttributes($json);
      ''';
    } else {
      javascriptString = '''
        Tawk_API = Tawk_API || {};
        Tawk_API.onLoad = function() {
          Tawk_API.setAttributes($json);
        };
      ''';
    }

    // _controller!.evaluateJavascript(javascriptString);
    _controller!.runJavaScript(javascriptString);
  }

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            if (widget.visitor != null) {
              _setUser(widget.visitor!);
            }

            if (widget.onLoad != null) {
              widget.onLoad!();
            }

            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == 'about:blank' ||
                request.url.contains('tawk.to')) {
              return NavigationDecision.navigate;
            }

            if (widget.onLinkTap != null) {
              widget.onLinkTap!(request.url);
            }

            return NavigationDecision.prevent;
          },
        ),
      );
    // ..addJavaScriptChannel(
    //   'Toaster',
    //   onMessageReceived: (JavaScriptMessage message) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(message.message)),
    //     );
    //   },
    // )
    // ..loadRequest(Uri.parse('https://flutter.dev'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        // WebView(
        //   initialUrl: widget.directChatLink,
        //   javascriptMode: JavaScriptMode.unrestricted,
        //   onWebViewCreated: (WebViewController webViewController) {
        //     setState(() {
        //       _controller = webViewController;
        //     });
        //   },
        //   navigationDelegate: (NavigationRequest request) {
        //     if (request.url == 'about:blank' ||
        //         request.url.contains('tawk.to')) {
        //       return NavigationDecision.navigate;
        //     }

        //     if (widget.onLinkTap != null) {
        //       widget.onLinkTap!(request.url);
        //     }

        //     return NavigationDecision.prevent;
        //   },
        //   onPageFinished: (_) {
        //     if (widget.visitor != null) {
        //       _setUser(widget.visitor!);
        //     }

        //     if (widget.onLoad != null) {
        //       widget.onLoad!();
        //     }

        //     setState(() {
        //       _isLoading = false;
        //     });
        //   },
        // ),
        _isLoading
            ? widget.placeholder ??
                const Center(
                  child: CircularProgressIndicator(),
                )
            : Container(),
      ],
    );
  }
}
