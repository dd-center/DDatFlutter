import 'package:flutter/material.dart';
import 'package:DDatFlutter/model/Release.dart';
import 'package:DDatFlutter/common/style/gsy_style.dart';
import 'package:DDatFlutter/common/utils/common_utils.dart';
import 'package:DDatFlutter/widget/gsy_card_item.dart';

/**
 * 版本TagItem
 * Created by guoshuyu
 * Date: 2018-07-30
 */

class ReleaseItem extends StatelessWidget {
  final ReleaseItemViewModel releaseItemViewModel;

  final GestureTapCallback onPressed;
  final GestureLongPressCallback onLongPress;

  ReleaseItem(this.releaseItemViewModel, {this.onPressed, this.onLongPress}) : super();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GSYCardItem(
        child: new InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          child: new Padding(
            padding: new EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: new Row(
              children: <Widget>[
                new Expanded(child: new Text(releaseItemViewModel.actionTitle, style: GSYConstant.smallTextBold)),
                new Container(child: new Text(releaseItemViewModel.actionTime ?? "", style: GSYConstant.smallSubText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReleaseItemViewModel {
  String actionTime;
  String actionTitle;
  String actionMode;
  String actionTarget;
  String actionTargetHtml;
  String body;

  ReleaseItemViewModel();

  ReleaseItemViewModel.fromMap(Release map) {
    if (map.publishedAt != null) {
      actionTime = CommonUtils.getNewsTimeStr(map.publishedAt);
    }
    actionTitle = map.name ?? map.tagName;
    actionTarget = map.targetCommitish;
    actionTargetHtml = map.bodyHtml;
    body = map.body ?? "";
  }
}
