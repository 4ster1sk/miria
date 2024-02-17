import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageDialog extends ConsumerStatefulWidget {
  final List<String> imageUrlList;
  final int initialPage;

  const ImageDialog({
    super.key,
    required this.imageUrlList,
    required this.initialPage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ImageDialogState();
}

class ImageDialogState extends ConsumerState<ImageDialog> {
  var scale = 1.0;
  late final pageController = PageController(initialPage: widget.initialPage);
  int pointersCount = 0;

  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
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
            child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
                    _transformationController.value = Matrix4.identity();
                    scale = 1.0;
                    pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  const SingleActivator(LogicalKeyboardKey.arrowRight): () {
                    _transformationController.value = Matrix4.identity();
                    scale = 1.0;
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                },
                child: Dismissible(
                  key: const ValueKey(""),
                  behavior: HitTestBehavior.translucent,
                  direction: (scale == 1.0 && pointersCount <= 1)
                      ? DismissDirection.vertical
                      : DismissDirection.none,
                  resizeDuration: null,
                  onDismissed: (_) => {Navigator.of(context).pop()},
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Focus(
                              autofocus: true,
                              child: Listener(
                                  onPointerDown: (event) {
                                    setState(() => pointersCount++);
                                  },
                                  onPointerUp: (event) {
                                    setState(() => pointersCount--);
                                  },
                                  child: GestureDetector(
                                    onDoubleTapDown: (details) {
                                      if (scale != 1.0) {
                                        _transformationController.value =
                                            Matrix4.identity();
                                        scale = 1.0;
                                      } else {
                                        final position = details.localPosition;
                                        _transformationController.value =
                                            Matrix4.identity()
                                            ..translate(
                                              -position.dx * 2, -position.dy * 2)
                                              ..scale(3.0);
                                        scale = 3.0;
                                      }
                                    },
                                    child: PageView(
                                      controller: pageController,
                                      physics: (scale == 1.0 && pointersCount <= 1)
                                          ? const ScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      children: [
                                        for (final url in widget.imageUrlList)
                                          ScaleNotifierInteractiveViewer(
                                            imageUrl: url,
                                            controller: _transformationController,
                                            onScaleChanged: (scaleUpdated) =>
                                                setState(() {
                                              scale = scaleUpdated;
                                            }),
                                          ),
                                      ],
                                    ),
                                  )))),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            constraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            fillColor: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withAlpha(200),
                            shape: const CircleBorder(),
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withAlpha(200)))),
                      ),
                      if (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                        Positioned(
                            right: 10,
                            top: 10,
                            child: RawMaterialButton(
                                onPressed: () async {
                                  final page = pageController.page?.toInt();
                                  if (page == null) return;
                                  final response = await ref.read(dioProvider).get(
                                  widget.imageUrlList[page],
                                          options: Options(
                                              responseType: ResponseType.bytes));

                                  if (defaultTargetPlatform ==
                                      TargetPlatform.android) {
                                    final androidInfo =
                                        await DeviceInfoPlugin().androidInfo;
                                    if (androidInfo.version.sdkInt <= 32) {
                                      final permissionStatus =
                                          await Permission.storage.status;
                                      if (permissionStatus.isDenied) {
                                        await Permission.storage.request();
                                      }
                                    } else {
                                      final permissionStatus =
                                          await Permission.photos.status;
                                      if (permissionStatus.isDenied) {
                                        await Permission.photos.request();
                                      }
                                    }
                                  }

                                  await ImageGallerySaver.saveImage(response.data);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(S.of(context).savedImage)));
                                },
                                constraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                                fillColor: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withAlpha(200),
                                shape: const CircleBorder(),
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(Icons.save,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withAlpha(200))))),
                    ],
                  )),
                )));
  }
}

class ScaleNotifierInteractiveViewer extends StatefulWidget {
  final String imageUrl;
  final TransformationController controller;
  final void Function(double) onScaleChanged;

  const ScaleNotifierInteractiveViewer({
    super.key,
    required this.imageUrl,
    required this.controller,
    required this.onScaleChanged,
  });

  @override
  State<StatefulWidget> createState() => ScaleNotifierInteractiveViewerState();
}

class ScaleNotifierInteractiveViewerState
    extends State<ScaleNotifierInteractiveViewer> {
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        child: InteractiveViewer(
          maxScale: 8.0,
          // ピンチイン・ピンチアウト終了後の処理
          transformationController: widget.controller,
          onInteractionEnd: (details) {
            scale = widget.controller.value.getMaxScaleOnAxis();
            widget.onScaleChanged(scale);
          },
          child: NetworkImageView(
            url: widget.imageUrl,
            type: ImageType.image,
            loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                    height: 48.0,
                    width: 48.0,
                    child: Center(child: CircularProgressIndicator()));
              }),
        ));
  }
}
