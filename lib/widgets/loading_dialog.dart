import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    super.key,
    this.message = 'Please wait...',
  });

  static void show(BuildContext context, {String message = 'Please wait...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => LoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    // Dismiss via the root Navigator the dialog was pushed onto. Using
    // go_router's context.pop() here could pop the underlying page route
    // instead of the dialog, leaving a stuck spinner or a blank screen.
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      // Use system theme background color instead of hardcoded white
      backgroundColor: theme.dialogBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              // Use primary color from theme for consistency
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              strokeWidth: 3.w,
            ),
            SizedBox(height: 16.h),
            // Text will inherit the correct color from the theme
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
