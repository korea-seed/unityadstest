import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unity Ads Example'),
        ),
        body: const SafeArea(child: UnityAdsExample()),
      ),
    );
  }
}

class UnityAdsExample extends StatefulWidget {
  const UnityAdsExample({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _UnityAdsExampleState createState() => _UnityAdsExampleState();
}

class _UnityAdsExampleState extends State<UnityAdsExample> {
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();

    UnityAds.init(
      gameId: AdManager.gameId,
      testMode: true,
      onComplete: () => print('Initialization Complete'),
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showBanner = !_showBanner;
                  });
                },
                child: Text(_showBanner ? 'Hide Banner' : 'Show Banner'),
              ),
              VideoAdButton(
                placementId: AdManager.rewardedVideoAdPlacementId,
                title: 'Show Rewarded Video',
              ),
              VideoAdButton(
                placementId: AdManager.interstitialVideoAdPlacementId,
                title: 'Show Interstitial Video',
              ),
            ],
          ),
          if (_showBanner)
            UnityBannerAd(
              placementId: AdManager.bannerAdPlacementId,
              onLoad: (placementId) => print('Banner loaded: $placementId'),
              onClick: (placementId) => print('Banner clicked: $placementId'),
              onFailed: (placementId, error, message) =>
                  print('Banner Ad $placementId failed: $error $message'),
            ),
        ],
      ),
    );
  }
}

class VideoAdButton extends StatefulWidget {
  const VideoAdButton(
      {Key? key, required this.placementId, required this.title})
      : super(key: key);

  final String placementId;
  final String title;

  @override
  _VideoAdButtonState createState() => _VideoAdButtonState();
}

class _VideoAdButtonState extends State<VideoAdButton> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    UnityAds.load(
      placementId: widget.placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        setState(() {
          _loaded = true;
        });
      },
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _loaded
          ? () {
              UnityAds.showVideoAd(
                placementId: widget.placementId,
                onComplete: (placementId) =>
                    print('Video Ad $placementId completed'),
                onFailed: (placementId, error, message) =>
                    print('Video Ad $placementId failed: $error $message'),
                onStart: (placementId) =>
                    print('Video Ad $placementId started'),
                onClick: (placementId) => print('Video Ad $placementId click'),
                onSkipped: (placementId) =>
                    print('Video Ad $placementId skipped'),
              );
            }
          : null,
      child: Text(widget.title),
    );
  }
}

class AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '4716911';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return '4716910';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Banner_Android';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Banner_iOS';
    }
    return '';
  }

  static String get interstitialVideoAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Interstitial_Android';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Interstitial_iOS';
    }
    return '';
  }

  static String get rewardedVideoAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Rewarded_Android';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Rewarded_iOS';
    }
    return '';
  }
}
