import 'package:bridging_saathi/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

vSpacer(double height) {
  return SizedBox(
    height: height.h,
  );
}

hSpacer(double width) {
  return SizedBox(
    width: width.w,
  );
}

/// A responsive page indicator that never overflows.
///
/// Uses a [Wrap] so the dots flow onto multiple centered lines when the
/// item count is larger than the available width (e.g. galleries/events
/// loaded from the API), instead of throwing a RenderFlex overflow.
Widget pageIndicator({
  required int count,
  required int currentIndex,
  required Color activeColor,
  Color? inactiveColor,
  double size = 8,
}) {
  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 8.w,
    runSpacing: 8.w,
    children: List.generate(
      count,
      (index) => Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index
              ? activeColor
              : (inactiveColor ?? Colors.grey[300]),
        ),
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String message, bool isSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<void> launchInBrowser(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  LoadingDialog.show(context);
  // if (await canLaunchUrl(uri)) {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
  // } else {
  if (context.mounted) {
    LoadingDialog.hide(context);
    // showSnackBar(context, 'Could not launch URL', false);
  }
  // }
}
