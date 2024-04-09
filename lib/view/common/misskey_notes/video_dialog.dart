import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:miria/extensions/duration.dart';

class VideoDialog extends StatefulWidget {
  const VideoDialog({super.key, required this.url, required this.fileType});

  final String url;
  final String fileType;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  //late final videoKey = GlobalKey<VideoState>();
  late final VideoPlayerController controller;
  late final bool isAudioFile;

  double aspectRatio = 1;

  int lastTapTime = 0;
  bool isVisibleControlBar = false;
  bool isEnabledButton = false;
  bool isFullScreen = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isAudioFile = widget.fileType.startsWith("audio");
    if (isAudioFile) {
      isVisibleControlBar = true;
      isEnabledButton = true;
    }

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        controller.play();
        setState(() {
          aspectRatio = controller.value.aspectRatio;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  if (isAudioFile) return;
                  timer?.cancel();
                  int now = DateTime.now().millisecondsSinceEpoch;
                  int elap = now - lastTapTime;
                  lastTapTime = now;
                  setState(() {
                    if (!isVisibleControlBar) {
                      isEnabledButton = true;
                      isVisibleControlBar = true;
                    } else if (elap > 500 &&
                        (event.localPosition.dy + 100 <
                                MediaQuery.of(context).size.height &&
                            max(event.localPosition.dx,
                                    event.localPosition.dy) >=
                                45)) {
                      isVisibleControlBar = false;
                    }
                  });
                },
                onPointerUp: (event) {
                  if (isAudioFile) return;
                  timer?.cancel();
                  timer = Timer(const Duration(seconds: 2), () {
                    if (!mounted) return;
                    setState(() {
                      isVisibleControlBar = false;
                    });
                  });
                },
                child: Dismissible(
                  key: const ValueKey(""),
                  behavior: HitTestBehavior.translucent,
                  direction: DismissDirection.vertical,
                  resizeDuration: null,
                  onDismissed: (_) => {Navigator.of(context).pop()},
                  child: Stack(
                    children: [
                      Align(
                          child: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: VideoPlayer(controller))),
                      (controller.value.isBuffering)
                          ? const Center(
                              child: SizedBox(
                                  height: 48.0,
                                  width: 48.0,
                                  child: CircularProgressIndicator()))
                          : Container(),
                      AnimatedOpacity(
                        curve: Curves.easeInOut,
                        opacity: isVisibleControlBar ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        onEnd: () {
                          if (mounted && !isVisibleControlBar) {
                            setState(() {
                              isEnabledButton = false;
                            });
                          }
                        },
                        child: Visibility(
                          maintainState: true,
                          maintainAnimation: true,
                          visible: isEnabledButton,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: _VideoControls(
                                  controller: controller,
                                  isAudioFile: isAudioFile,
                                  onMenuPressed: () => {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (innerContext) {
                                        return ListView(
                                          children: [
                                            ListTile(
                                                leading: const Icon(
                                                    Icons.open_in_browser),
                                                title: Text(
                                                    S.of(context).openBrowsers),
                                                onTap: () async {
                                                  Navigator.of(innerContext)
                                                      .pop();
                                                  Navigator.of(context).pop();
                                                  launchUrlString(
                                                    widget.url,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                                }),
                                            if (!isAudioFile)
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.fullscreen),
                                                title: Text(S
                                                    .of(context)
                                                    .changeFullScreen),
                                                onTap: () async {
                                                  Navigator.of(innerContext)
                                                      .pop();
                                                  /*(videoKey.currentState
                                                      ?.enterFullscreen();*/
                                                },
                                              )
                                          ],
                                        );
                                      },
                                    )
                                  },
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 10,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  constraints: const BoxConstraints(
                                      minWidth: 0, minHeight: 0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  fillColor: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withAlpha(200),
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.close,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withAlpha(200),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _VideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final double iconSize = 30.0;
  final VoidCallback? onMenuPressed;
  final bool isAudioFile;

  const _VideoControls(
      {required this.controller,
      required this.isAudioFile,
      this.onMenuPressed});

  @override
  State<_VideoControls> createState() => _VideoControlState();
}

class _VideoControlState extends State<_VideoControls> {
  final List<StreamSubscription> subscriptions = [];
  late final VoidCallback _listener;

  Duration position = const Duration(seconds: 0);
  _VideoControlState() {
    _listener = () {
      // 検知したタイミングで再描画する
      setState(() {});
    };
  }

  bool isSeeking = false;
  bool isMute = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSeeking) {
      position = widget.controller.value.position;
    }

    final duration = widget.controller.value.duration;

    int maxBuffering = 0;
    for (final DurationRange range in widget.controller.value.buffered) {
      final int end = range.end.inMilliseconds;
      if (end > maxBuffering) {
        maxBuffering = end;
      }
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              top: BorderSide(
            color: Theme.of(context).primaryColor,
          ))),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            iconSize: widget.iconSize,
                            onPressed: () => widget.controller.value.isPlaying
                                ? widget.controller.pause()
                                : widget.controller.play(),
                            icon: Icon(widget.controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow)),
                      ),
                      Text(position.label(reference: duration),
                          textAlign: TextAlign.center),
                      const Text(" / "),
                      Text(duration.label(reference: duration),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  IconButton(
                      iconSize: widget.iconSize,
                      onPressed: () {
                        widget.controller.setVolume(isMute ? 100 : 0);
                        isMute = !isMute;
                      },
                      icon:
                          Icon((isMute) ? Icons.volume_off : Icons.volume_up)),
                  IconButton(
                    onPressed: widget.onMenuPressed,
                    icon: const Icon(Icons.more_horiz),
                    iconSize: widget.iconSize,
                  )
                ])),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SliderTheme(
                      data: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 3.0,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6.0)),
                      child: Slider(
                        thumbColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).primaryColor,
                        value: position.inMilliseconds.toDouble(),
                        secondaryTrackValue: maxBuffering.toDouble(),
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        onChangeStart: (double value) {
                          isSeeking = true;
                        },
                        onChanged: (double value) {
                          setState(() {
                            position = Duration(milliseconds: value.toInt());
                          });
                        },
                        onChangeEnd: (double value) {
                          widget.controller.seekTo(position);
                          isSeeking = false;
                        },
                      )))
            ])
      ]),
    );
  }
}
