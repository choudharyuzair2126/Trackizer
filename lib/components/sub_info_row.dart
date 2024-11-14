import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class SubInfoRow extends StatelessWidget {
  final String leftText;
  final String rightText;
  final VoidCallback action;
  const SubInfoRow({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(
              fontSize: 16, color: Colour.white, fontWeight: FontWeight.w700),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.26,
              child: Text(
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                rightText,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 13,
                  color: Colour.grey30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              onPressed: action,
              icon: Icon(
                CupertinoIcons.right_chevron,
                color: Colour.grey30,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
