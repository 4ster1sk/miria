import "dart:io";
import "dart:math";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/common/download_file_notifier.dart";
import "package:miria/view/common/interactive_viewer.dart" as iv;
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher_string.dart";

class ImageDialog extends HookConsumerWidget {
  final List<DriveFile> driveFiles;
  final int initialPage;

  const ImageDialog({
    required this.driveFiles,
    required this.initialPage,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = useState(1.0);
    final pageController = usePageController(initialPage: initialPage);
    final pointersCount = useState(0);

    final maxScale = useState(8.0);
    final lastScale = useState(1.0);

    final currentPage = useState(0);

    final isDoubleTap = useState(false);
    final lastDoubleTapDetails = useState<TapDownDetails?>(null);

    final transformationController = useTransformationController();

    final resetScale = useCallback(
      () {
        transformationController.value = Matrix4.identity();
        scale.value = 1.0;
      },
      [transformationController, scale],
    );
    final isDesktop = !(Platform.isAndroid || Platform.isIOS);

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
            const SingleActivator(LogicalKeyboardKey.arrowLeft): () async {
              resetScale();
              await pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            const SingleActivator(LogicalKeyboardKey.arrowRight): () async {
              resetScale();
              await pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          },
          child: Dismissible(
            key: const ValueKey(""),
            behavior: HitTestBehavior.translucent,
            direction: (!isDoubleTap.value &&
                    scale.value == 1.0 &&
                    pointersCount.value <= 1)
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
                      onPointerDown: (event) => pointersCount.value++,
                      onPointerUp: (event) {
                        pointersCount.value--;
                        if (isDoubleTap.value) {
                          if (scale.value == 1.0) resetScale();

                          isDoubleTap.value = false;
                        }
                      },
                      onPointerMove: (event) {
                        if (isDoubleTap.value && pointersCount.value == 1) {
                          final position =
                              lastDoubleTapDetails.value!.localPosition;
                          final delta = event.localPosition - position;

                          scale.value = max(
                            min(
                              lastScale.value + (delta.dy / 75.0),
                              maxScale.value,
                            ),
                            1.0,
                          );
                          final v = transformationController.toScene(position);

                          transformationController.value = Matrix4.identity()
                            ..scale(scale);

                          final v2 =
                              transformationController.toScene(position) - v;

                          transformationController.value =
                              transformationController.value.clone()
                                ..translate(v2.dx, v2.dy);
                        }
                      },
                      child: GestureDetector(
                        onDoubleTapDown: (details) {
                          isDoubleTap.value = true;
                          lastDoubleTapDetails.value = details;
                          lastScale.value = scale.value;
                        },
                        onDoubleTap: () {
                          if (scale.value != 1.0) {
                            resetScale();
                          } else if (lastDoubleTapDetails.value != null) {
                            final position =
                                lastDoubleTapDetails.value!.localPosition;
                            transformationController.value = Matrix4.identity()
                              ..translate(
                                -position.dx * 2,
                                -position.dy * 2,
                              )
                              ..scale(3.0);
                            scale.value = 3.0;
                          }
                          isDoubleTap.value = false;
                        },
                        onSecondaryTap: () async {
                          if (!isDesktop) return;
                          await showModalBottomSheet(
                            context: context,
                            builder: (innerContext) {
                              return ListView(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.open_in_browser,
                                    ),
                                    title: Text(
                                      S.of(context).openBrowsers,
                                    ),
                                    onTap: () async {
                                      Navigator.of(innerContext).pop();
                                      Navigator.of(context).pop();
                                      await launchUrlString(
                                        driveFiles[currentPage.value].url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (int index) {
                            currentPage.value = index;
                          },
                          physics: (!isDoubleTap.value &&
                                  scale.value == 1.0 &&
                                  pointersCount.value <= 1)
                              ? const ScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          children: [
                            for (final file in driveFiles)
                              ScaleNotifierInteractiveViewer(
                                imageUrl: file.url,
                                controller: transformationController,
                                onScaleChanged: (scaleUpdated) =>
                                    scale.value = scaleUpdated,
                                maxScale: maxScale.value,
                                isEnableScale: !isDoubleTap.value,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (driveFiles.length > 1) Positioned(
                  left: 0,
                  bottom: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(driveFiles.length, (index) {
                        return Container(
                          width: MediaQuery.of(context).size.width /
                              driveFiles.length, // 縦線の幅
                          height: 3, // 縦線の高さ
                          color: (currentPage.value == index)
                              ? Theme.of(context).primaryColor
                              : Colors.transparent, // 縦線の色
                        );
                      })),
                ),
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
                if (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: RawMaterialButton(
                      onPressed: () async {
                        final page = pageController.page?.toInt();
                        if (page == null) return;
                        final driveFile = driveFiles[page];
                        await ref
                            .read(downloadFileNotifierProvider.notifier)
                            .downloadFile(driveFile);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).savedImage)),
                        );
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
                        child: Icon(
                          Icons.save,
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
        ),
      ),
    );
  }
}

class ScaleNotifierInteractiveViewer extends StatefulWidget {
  final String imageUrl;
  final TransformationController controller;
  final void Function(double) onScaleChanged;
  final double maxScale;
  final bool isEnableScale;

  const ScaleNotifierInteractiveViewer({
    required this.imageUrl,
    required this.controller,
    required this.onScaleChanged,
    required this.maxScale,
    required this.isEnableScale,
    super.key,
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
      child: iv.InteractiveViewer(
        maxScale: widget.maxScale,
        isEnableScale: widget.isEnableScale,
        // ピンチイン・ピンチアウト終了後の処理
        transformationController: widget.controller,
        onInteractionEnd: (details) {
          scale = widget.controller.value.getMaxScaleOnAxis();
          widget.onScaleChanged(scale);
        },
        child: NetworkImageView(
          url: widget.imageUrl,
          type: ImageType.image,
          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              height: 48.0,
              width: 48.0,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          },
        ),
      ),
    );
  }
}
