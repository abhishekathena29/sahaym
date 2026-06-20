import 'dart:io' show Platform;

import 'package:bridging_saathi/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('More', style: TextStyle(fontSize: 18.sp)),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                children: [
                  // Card(
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12.r),
                  //   ),
                  //   child: ListTile(
                  //     onTap: () {
                  //       context.push('/profile');
                  //     },
                  //     leading: Icon(Icons.health_and_safety,
                  //         color: theme.colorScheme.primary, size: 24.sp),
                  //     title: Text('Profile',
                  //         style: theme.textTheme.bodyLarge?.copyWith(
                  //           fontSize: 16.sp,
                  //         )),
                  //     trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                  //   ),
                  // ),
                  // SizedBox(height: 8.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.privacy_tip_outlined,
                        color: theme.colorScheme.primary,
                        size: 24.sp,
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        launchInBrowser(
                          context,
                          'https://sahaym.in/privacy-policy/',
                        );
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 24.sp,
                      ),
                      title: Text(
                        'About',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        launchInBrowser(context, 'https://sahaym.in/about-us/');
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                    ),
                  ),
                  // "Visit Website" is hidden on iOS: Apple rejects apps that
                  // act as a wrapper/shortcut to an external website.
                  if (!Platform.isIOS) ...[
                    SizedBox(height: 8.h),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.public,
                          color: theme.colorScheme.primary,
                          size: 24.sp,
                        ),
                        title: Text(
                          'Visit Website',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        onTap: () {
                          launchInBrowser(context, 'https://sahaym.in');
                        },
                        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                      ),
                    ),
                  ],
                  // SizedBox(height: 8.h),
                  // Card(
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12.r),
                  //   ),
                  //   child: ListTile(
                  //     leading: Icon(Icons.logout,
                  //         color: theme.colorScheme.error, size: 24.sp),
                  //     title: Text('Logout',
                  //         style: theme.textTheme.bodyLarge?.copyWith(
                  //           color: theme.colorScheme.error,
                  //           fontSize: 16.sp,
                  //         )),
                  //     onTap: () {
                  //       context.read<PhoneAuthCubit>().logout();
                  //     },
                  //     trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
              child: Column(
                children: [
                  Text(
                    '© 2025 Sahaym. An initiative by Aaravdeep Sindhu.',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
