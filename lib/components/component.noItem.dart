import 'package:flutter/material.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/ui/theme.dart';

class NoItemWidget extends StatelessWidget {
  const NoItemWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_outlined,
              size: 70.0,
              color: AppThemeData().iconColor,
            ),
            Text(
              S.of(context).there_are_no_items,
              style: TextStyle(
                color: AppThemeData().textColor,
                fontSize: 20.0
              ),
            ),
          ],
        ),
      ),
    );
  }
}