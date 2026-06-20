import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w400,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sahaym',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'An initiative by ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      TextSpan(
                        text: 'Aaravdeep Sindhu',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' to spread awareness about health, link to official public-health resources, and provide health advisory for senior citizens. Sahaym is an independent app and is not affiliated with any government entity.',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: onClose,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade800,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
