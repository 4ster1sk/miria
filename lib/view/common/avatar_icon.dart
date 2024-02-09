import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AvatarIcon extends StatefulWidget {
  final User user;
  final double height;
  final VoidCallback? onTap;
  final bool isVisibleOnlineStatus;

  const AvatarIcon({
    super.key,
    required this.user,
    this.height = 48,
    this.onTap,
    this.isVisibleOnlineStatus = false,
  });

  @override
  State<StatefulWidget> createState() => AvatarIconState();
}

class AvatarIconState extends State<AvatarIcon> {
  Color? catEarColor;

  Color? averageColor() {
    // https://github.com/woltapp/blurhash/blob/master/Algorithm.md
    final blurhash = widget.user.avatarBlurhash;
    if (blurhash == null) {
      return null;
    }
    final value = blurhash
        .substring(2, 6)
        .split("")
        .map(
          r'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~'
              .indexOf,
        )
        .fold(0, (acc, i) => acc * 83 + i);
    return Color(0xFF000000 | value);
  }

  @override
  void initState() {
    super.initState();

    catEarColor = (widget.user.isCat ? averageColor() : null);
  }

  @override
  Widget build(BuildContext context) {
    final baseHeight = MediaQuery.textScalerOf(context).scale(widget.height);
    final Color statusColor;
    switch (widget.user.onlineStatus) {
      case OnlineStatus.online:
        statusColor = const Color.fromARGB(255, 88, 212, 201); // #58d4c9
      case OnlineStatus.active:
        statusColor = const Color.fromARGB(255, 228, 188, 72); // #e4bc48
      case OnlineStatus.offline:
        statusColor = const Color.fromARGB(255, 234, 83, 83); // #ea5353
      case OnlineStatus.unknown:
      case null:
        statusColor = const Color.fromARGB(255, 136, 136, 136); // #888
    }

    return GestureDetector(
      onTap: widget.onTap ??
          () {
            context.pushRoute(
              UserRoute(
                  userId: widget.user.id, account: AccountScope.of(context)),
            );
          },
      child: Padding(
        padding: EdgeInsets.only(
          top: 3,
          left: MediaQuery.textScalerOf(context).scale(15),
          right: MediaQuery.textScalerOf(context).scale(5),
        ),
        child: Stack(
          children: [
            if (widget.user.isCat)
              Positioned(
                left: 0,
                top: 0,
                width: baseHeight,
                height: baseHeight,
                child: Transform.rotate(
                  angle: -0 * pi / 180,
                  child: Transform.translate(
                    offset: Offset(
                      -baseHeight * 0.333,
                      -baseHeight * 0.3,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: catEarColor ?? Theme.of(context).primaryColor,
                      size: baseHeight,
                    ),
                  ),
                ),
              ),
            if (widget.user.isCat)
              Positioned(
                left: 0,
                top: 0,
                width: baseHeight,
                height: baseHeight,
                child: Transform.translate(
                  offset: Offset(
                    baseHeight * 1.333,
                    -baseHeight * 0.3,
                  ),
                  child: Transform(
                    transform: Matrix4.rotationY(pi),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: catEarColor ?? Theme.of(context).primaryColor,
                      size: baseHeight,
                    ),
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(baseHeight),
              child: SizedBox(
                width: baseHeight,
                height: baseHeight,
                child: NetworkImageView(
                  fit: BoxFit.cover,
                  url: widget.user.avatarUrl.toString(),
                  type: ImageType.avatarIcon,
                ),
              ),
            ),
            for (final decoration in widget.user.avatarDecorations)
              Transform.scale(
                scaleX: 2,
                scaleY: 2,
                child: Transform.translate(
                  offset: Offset(
                    baseHeight * decoration.offsetX,
                    baseHeight * decoration.offsetY,
                  ),
                  child: Transform.rotate(
                    angle: (decoration.angle ?? 0) * 2 * pi,
                    alignment: Alignment.center,
                    child: decoration.flipH
                        ? Transform.flip(
                            flipX: true,
                            child: SizedBox(
                              width: baseHeight,
                              child: NetworkImageView(
                                  url: decoration.url, type: ImageType.other),
                            ),
                          )
                        : SizedBox(
                            width: baseHeight,
                            child: NetworkImageView(
                                url: decoration.url,
                                type: ImageType.avatarDecoration)),
                  ),
                ),
              ),
          if (widget.isVisibleOnlineStatus)
            Positioned(
              left: 0,
              top: 0,
              width: baseHeight * 0.25,
              height: baseHeight * 0.25,
              child: Transform.translate(
                offset: Offset(
                  -baseHeight * 0.02,
                  baseHeight * 0.78,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: baseHeight * 0.03)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
