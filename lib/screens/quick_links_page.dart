import 'dart:async';
import 'dart:io' show Platform;
import 'package:bridging_saathi/logic/model/event/event.dart';
import 'package:bridging_saathi/screens/cubit/event/event_cubit.dart';
import 'package:bridging_saathi/screens/cubit/event/event_state.dart';
import 'package:bridging_saathi/theme/img.dart';
import 'package:bridging_saathi/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:bridging_saathi/screens/webview_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bridging_saathi/screens/cubit/photo/photo_cubit.dart';
import 'package:bridging_saathi/screens/cubit/photo/photo_state.dart';
import 'package:bridging_saathi/screens/cubit/video/video_cubit.dart';
import 'package:bridging_saathi/screens/cubit/video/video_state.dart';
import 'package:bridging_saathi/screens/video_player_screen.dart';
import 'package:bridging_saathi/logic/model/photo/photo.dart';
import 'package:bridging_saathi/logic/model/video/video.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QuickLinksPage extends StatefulWidget {
  const QuickLinksPage({super.key});

  @override
  State<QuickLinksPage> createState() => _QuickLinksPageState();
}

class _QuickLinksPageState extends State<QuickLinksPage> {
  final PageController _consultationPageController = PageController();
  final PageController _galleryPageController = PageController();
  final PageController _eventsPageController = PageController();
  final PageController _videoPageController = PageController();
  int _currentConsultationPage = 0;
  int _currentGalleryPage = 0;
  int _currentEventPage = 0;
  int _currentVideoPage = 0;
  Timer? _autoScrollTimer;
  Timer? _galleryScrollTimer;
  Timer? _eventsScrollTimer;
  Timer? _videoScrollTimer;
  final PageController _cardsPageController = PageController();
  int _currentCardPage = 0;
  Timer? _cardsScrollTimer;
  List<Widget> _cardsList = [];

  final List<String> consultationImages = [
    doctorConsultation,
    doctorConsultation2,
    doctorConsultation3,
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PhotoCubit>().loadPhotos();
      context.read<VideoCubit>().loadVideos();
      context.read<EventCubit>().loadEvents();
      _buildCardsList();
      _startCardsAutoScroll();
    });
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _stopGalleryAutoScroll();
    _stopEventsAutoScroll();
    _stopVideoAutoScroll();
    _stopCardsAutoScroll();
    _consultationPageController.dispose();
    _galleryPageController.dispose();
    _eventsPageController.dispose();
    _videoPageController.dispose();
    _cardsPageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_consultationPageController.hasClients) {
        final nextPage =
            (_currentConsultationPage + 1) % consultationImages.length;
        _consultationPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _startGalleryAutoScroll(List<Photo> photos) {
    // Cancel existing timer if there is one
    _stopGalleryAutoScroll();

    _galleryScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_galleryPageController.hasClients && photos.isNotEmpty) {
        final nextPage = (_currentGalleryPage + 1) % photos.length;
        _galleryPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopGalleryAutoScroll() {
    _galleryScrollTimer?.cancel();
    _galleryScrollTimer = null;
  }

  void _startEventsAutoScroll(List<Event> events) {
    // Cancel existing timer if there is one
    _stopEventsAutoScroll();

    _eventsScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_eventsPageController.hasClients && events.isNotEmpty) {
        final nextPage = (_currentEventPage + 1) % events.length;
        _eventsPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopEventsAutoScroll() {
    _eventsScrollTimer?.cancel();
    _eventsScrollTimer = null;
  }

  void _startVideoAutoScroll(List<Video> videos) {
    _stopVideoAutoScroll();

    _videoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_videoPageController.hasClients && videos.isNotEmpty) {
        final nextPage = (_currentVideoPage + 1) % videos.length;
        _videoPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopVideoAutoScroll() {
    _videoScrollTimer?.cancel();
    _videoScrollTimer = null;
  }

  void _startCardsAutoScroll() {
    _cardsScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_cardsPageController.hasClients && _cardsList.isNotEmpty) {
        final nextPage = (_currentCardPage + 1) % _cardsList.length;
        _cardsPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopCardsAutoScroll() {
    _cardsScrollTimer?.cancel();
    _cardsScrollTimer = null;
  }

  Widget _buildVideoThumbnail(Video video) {
    if (video.isYouTubeUrl && video.youtubeThumbnailUrl != null) {
      return SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl: video.youtubeThumbnailUrl!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF263238),
                  Color(0xFF37474F),
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.w,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF263238),
                    Color(0xFF37474F),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 72.sp,
                ),
              ),
            );
          },
        ),
      );
    }

    // Non-YouTube videos show a play-icon placeholder over a gradient.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF263238),
            Color(0xFF37474F),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white,
          size: 72.sp,
        ),
      ),
    );
  }

  void _buildCardsList() {
    _cardsList = [
      _buildCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WebViewScreen(
                title: 'Health Awareness',
                url: 'https://sahaym.in/health-awareness/en/',
              ),
            ),
          );
          // launchInBrowser(context, 'https://sahaym.in/health-awareness/en/');
        },
        title: 'Health Awareness',
        content: 'Stay informed about health tips and awareness programs.',
        gradientColors: const [
          Color(0xFF1E88E5),
          Color(0xFF1A237E),
        ],
        imagePath: sahaym1,
      ),
      _buildCard(
        onTap: () {
          launchInBrowser(context, 'https://abha.abdm.gov.in/abha/v3/register');
        },
        title: 'Create Abha ID',
        content:
            'Create your ABHA account on the official Ayushman Bharat portal.',
        sourceLabel: 'abha.abdm.gov.in',
        sourceUrl: 'https://abha.abdm.gov.in/abha/v3/register',
        gradientColors: const [
          Color(0xFF1E88E5),
          Color(0xFF1A237E),
        ],
        imagePath: abha,
      ),
      _buildCard(
        onTap: () {
          launchInBrowser(
              context, 'https://esanjeevani.mohfw.gov.in/#/patient/signin');
        },
        title: 'E Sanjeevni',
        content:
            'Access the official eSanjeevani telemedicine consultation portal.',
        sourceLabel: 'esanjeevani.mohfw.gov.in',
        sourceUrl: 'https://esanjeevani.mohfw.gov.in/#/patient/signin',
        gradientColors: const [
          Color(0xFF1E88E5),
          Color(0xFF1A237E),
        ],
        imagePath: eSanjeevni,
      ),
      _buildCard(
        onTap: () {
          launchInBrowser(context, "https://telemanas.mohfw.gov.in/home");
        },
        title: 'Telemanas',
        content:
            'Visit the official Tele-MANAS portal for mental-health support.',
        sourceLabel: 'telemanas.mohfw.gov.in',
        sourceUrl: 'https://telemanas.mohfw.gov.in/home',
        gradientColors: const [
          Color(0xFF1E88E5),
          Color(0xFF1A237E),
        ],
        imagePath: telemanas,
      ),
      _buildUrlCard(
        onApplyTap: () =>
            launchInBrowser(context, 'https://beneficiary.nha.gov.in/'),
        onUrlTap: () {
          launchInBrowser(context, 'https://beneficiary.nha.gov.in/');
        },
        title: 'Ayushman Card',
        content: 'Check beneficiary services on the official NHA portal.',
        url: 'beneficiary.nha.gov.in',
        sourceLabel: 'beneficiary.nha.gov.in',
        sourceUrl: 'https://beneficiary.nha.gov.in/',
        gradientColors: const [
          Color(0xFF1E88E5),
          Color(0xFF1A237E),
        ],
        imagePath: ayushman,
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Links', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // "Visit Website" is hidden on iOS: Apple rejects apps that act as
          // a wrapper/shortcut to an external website.
          if (!Platform.isIOS)
            TextButton.icon(
              onPressed: () {
                launchInBrowser(context, 'https://sahaym.in');
              },
              icon: Icon(Icons.public, color: Colors.white, size: 20.sp),
              label: Text(
                'Visit Website',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer Banner
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_outlined,
                        color: Colors.blue.shade700, size: 18.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disclaimer',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Sahaym is an independent health-awareness app and is not affiliated with, endorsed by, or authorized by any government entity.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Consultation Banner
                    _buildDoctorConsultationBanner(context),
                    vSpacer(16),

                    // Health Awareness Banner
                    _buildHealthAwarenessBanner(),
                    vSpacer(16),

                    // Latest Events Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Latest Events",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    vSpacer(16),
                    Text(
                      "Stay updated with our upcoming health awareness sessions and activities",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                    vSpacer(24),

                    // Event Cards with Carousel from API
                    _buildEventsSection(),
                    vSpacer(32),

                    // Video Gallery Section
                    _buildVideoGallerySection(),
                    vSpacer(32),

                    // Quick Links Cards (Horizontal)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Quick Links",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        vSpacer(8),
                        SizedBox(
                          height: 180.h,
                          child: PageView.builder(
                            controller: _cardsPageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentCardPage = index;
                              });
                            },
                            itemCount: _cardsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: _cardsList[index],
                              );
                            },
                          ),
                        ),
                        vSpacer(16),
                        // Pagination Indicators for Cards
                        pageIndicator(
                          count: _cardsList.length,
                          currentIndex: _currentCardPage,
                          activeColor: primaryColor,
                        ),
                      ],
                    ),
                    vSpacer(24),

                    // Photo Gallery Section
                    _buildPhotoGallerySection(),
                    vSpacer(16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.r),
                      child: _buildOfficialSourcesSection(),
                    ),
                    vSpacer(16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsSection() {
    final primaryColor = Theme.of(context).primaryColor;

    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2.w,
              ),
            ),
          );
        } else if (state is EventLoaded) {
          final events = state.events;

          // Start auto-scrolling when events are loaded
          if (events.isNotEmpty && _eventsScrollTimer == null) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _startEventsAutoScroll(events);
            });
          }

          return Column(
            children: [
              SizedBox(
                height: 230.h, // Increased height for better display
                child: PageView.builder(
                  controller: _eventsPageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentEventPage = index;
                    });
                  },
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildEventCard(
                      context,
                      event: event,
                    );
                  },
                ),
              ),
              vSpacer(16),
              // Pagination Indicators
              pageIndicator(
                count: events.length,
                currentIndex: _currentEventPage,
                activeColor: primaryColor,
                size: 12,
              ),
              vSpacer(16),
              Text(
                "Showing ${_currentEventPage + 1} of ${events.length} events",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          );
        } else if (state is EventError) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.sp,
                  ),
                  vSpacer(16),
                  Text(
                    "Failed to load events",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                  ),
                  vSpacer(8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EventCubit>().loadEvents();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Retry",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                "No events available",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPhotoGallerySection() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Photo Gallery",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        vSpacer(16),
        Text(
          "Browse through our collection of memories and moments",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black54,
          ),
        ),
        vSpacer(24),

        // Gallery Grid with Auto-scrolling Row (using BlocBuilder)
        BlocBuilder<PhotoCubit, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              );
            } else if (state is PhotoLoaded) {
              final photos = state.photos;

              // Start auto-scrolling when photos are loaded
              if (photos.isNotEmpty && _galleryScrollTimer == null) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _startGalleryAutoScroll(photos);
                });
              }

              return SizedBox(
                height: 280.h,
                child: Column(
                  children: [
                    // Auto-scrolling image carousel
                    Expanded(
                      child: PageView.builder(
                        controller: _galleryPageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentGalleryPage = index;
                          });
                        },
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl: photos[index].photoUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.w,
                                            color: primaryColor,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.error,
                                          size: 40.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),

                                    // Photo caption overlay
                                    // Positioned(
                                    //   bottom: 0,
                                    //   left: 0,
                                    //   right: 0,
                                    //   child: Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         vertical: 8.h, horizontal: 16.w),
                                    //     decoration: BoxDecoration(
                                    //       gradient: LinearGradient(
                                    //         begin: Alignment.bottomCenter,
                                    //         end: Alignment.topCenter,
                                    //         colors: [
                                    //           Colors.black.withOpacity(0.7),
                                    //           Colors.transparent,
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     child: Text(
                                    //       photos[index].name,
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 18.sp,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    vSpacer(16),

                    // Indicator dots
                    pageIndicator(
                      count: photos.length,
                      currentIndex: _currentGalleryPage,
                      activeColor: primaryColor,
                    ),
                    vSpacer(16),

                    // Photo counter text
                    Text(
                      "Photo ${_currentGalleryPage + 1} of ${photos.length}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is PhotoError) {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48.sp,
                      ),
                      vSpacer(16),
                      Text(
                        "Failed to load photos",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                      ),
                      vSpacer(8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PhotoCubit>().loadPhotos();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: Text(
                    "No photos available",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildVideoGallerySection() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Video Gallery",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        vSpacer(16),
        Text(
          "Watch health awareness and program highlight videos",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black54,
          ),
        ),
        vSpacer(24),
        BlocBuilder<VideoCubit, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return SizedBox(
                height: 240.h,
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              );
            } else if (state is VideoLoaded) {
              final videos = state.videos;

              if (videos.isNotEmpty && _videoScrollTimer == null) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _startVideoAutoScroll(videos);
                });
              }

              return SizedBox(
                height: 330.h,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _videoPageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentVideoPage = index;
                          });
                        },
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: _buildVideoThumbnail(video),
                                    ),
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            decoration: const BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 42.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                          horizontal: 16.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.75),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          video.displayTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InAppVideoPlayerScreen(
                                                  videoUrl: video.videoUrl,
                                                  title: video.displayTitle,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    vSpacer(16),
                    pageIndicator(
                      count: videos.length,
                      currentIndex: _currentVideoPage,
                      activeColor: primaryColor,
                    ),
                    vSpacer(12),
                    Text(
                      "Video ${_currentVideoPage + 1} of ${videos.length}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is VideoError) {
              return SizedBox(
                height: 220.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48.sp,
                      ),
                      vSpacer(16),
                      Text(
                        "Failed to load videos",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                      ),
                      vSpacer(8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<VideoCubit>().loadVideos();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: Text(
                    "No videos available",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDoctorConsultationBanner(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.r),
      decoration: BoxDecoration(
        color: Colors.white, // Light cream background
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220.h,
            child: PageView.builder(
              controller: _consultationPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentConsultationPage = index;
                });
              },
              itemCount: consultationImages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Center(
                    child: Image.asset(
                      consultationImages[index],
                      height: 220.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            ),
          ),
          vSpacer(16),
          pageIndicator(
            count: consultationImages.length,
            currentIndex: _currentConsultationPage,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthAwarenessBanner() {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Awareness Pill
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6FA), // Light purple background
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              "HEALTH AWARENESS",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          vSpacer(14),

          // Main Heading
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 36.sp, // Adjusted for better readability
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2736), // Dark blue/black
                height: 1.1,
              ),
              children: [
                const TextSpan(text: "Promoting Health\n& Wellness\nin "),
                TextSpan(
                  text: "Elderly.",
                  style: TextStyle(
                    backgroundColor:
                        const Color(0xFFE6E6FA), // Light purple background
                    color: primaryColor, // Theme primary color
                    fontSize: 36.sp, // Adjusted for better readability
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          vSpacer(24),

          // Description
          Text(
            "SAHAYM a dedicated platform made to serve as a resource hub, offering information on preventive care, chronic disease, and strategies for quality Wellbeing among seniors. SAHAYM aims to promote dignity, independence & a better quality of life for elderly.",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          vSpacer(16),

          // Action button
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        title: 'Health Awareness',
                        url: 'https://sahaym.in/health-awareness/en/',
                      ),
                    ),
                  );
                  // launchInBrowser(
                  //     context, 'https://sahaym.in/health-awareness/en/');
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Learn More",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      hSpacer(8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    required List<Color> gradientColors,
    required String imagePath,
    String? sourceLabel,
    String? sourceUrl,
    VoidCallback? onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width -
            16.w, // Reduced padding for more width
        height: 170.h, // Using screen util
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r), // Using screen util
          gradient: LinearGradient(
            colors: [
              secondaryColor,
              primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22.sp, // Using screen util
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h), // Using screen util
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16.sp, // Using screen util
                      color: Colors.white70,
                    ),
                    maxLines: 2, // Limit text to two lines
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis if text overflows
                  ),
                  if (sourceLabel != null && sourceUrl != null) ...[
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () => launchInBrowser(context, sourceUrl),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.link, color: Colors.white, size: 16.sp),
                          hSpacer(4),
                          Flexible(
                            child: Text(
                              'Official source: $sourceLabel',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(), // Add spacer to push the learn more button to the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Learn More",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          hSpacer(4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlCard({
    required String title,
    required String content,
    required String url,
    required List<Color> gradientColors,
    required String imagePath,
    String? sourceLabel,
    String? sourceUrl,
    VoidCallback? onCardTap,
    VoidCallback? onUrlTap,
    VoidCallback? onApplyTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: onCardTap ?? onApplyTap,
      child: Container(
        width: MediaQuery.of(context).size.width -
            16.w, // Reduced padding for more width
        height: 170.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [
              secondaryColor,
              primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  vSpacer(8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                    maxLines: 2, // Limit text to two lines
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis if text overflows
                  ),
                  if (sourceLabel != null && sourceUrl != null) ...[
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () => launchInBrowser(context, sourceUrl),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.link, color: Colors.white, size: 16.sp),
                          hSpacer(4),
                          Flexible(
                            child: Text(
                              'Official source: $sourceLabel',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(), // Add spacer to push the learn more button to the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: onUrlTap,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  url,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              hSpacer(4),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficialSourcesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.blueGrey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.source_outlined,
                  color: Theme.of(context).primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Official Sources',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          vSpacer(8),
          Text(
            'Tap any link below to open the original official website used for that service.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.blueGrey[700],
            ),
          ),
          vSpacer(12),
          _buildSourceLinkTile(
            title: 'ABHA',
            url: 'https://abha.abdm.gov.in/abha/v3/register',
            onTap: () => launchInBrowser(
              context,
              'https://abha.abdm.gov.in/abha/v3/register',
            ),
          ),
          _buildSourceLinkTile(
            title: 'eSanjeevani',
            url: 'https://esanjeevani.mohfw.gov.in/#/patient/signin',
            onTap: () => launchInBrowser(
              context,
              'https://esanjeevani.mohfw.gov.in/#/patient/signin',
            ),
          ),
          _buildSourceLinkTile(
            title: 'TeleMANAS',
            url: 'https://telemanas.mohfw.gov.in/home',
            onTap: () => launchInBrowser(
              context,
              'https://telemanas.mohfw.gov.in/home',
            ),
          ),
          _buildSourceLinkTile(
            title: 'Ayushman Bharat',
            url: 'https://beneficiary.nha.gov.in/',
            onTap: () => launchInBrowser(
              context,
              'https://beneficiary.nha.gov.in/',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceLinkTile({
    required String title,
    required String url,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.blueGrey.shade100),
      ),
      child: ListTile(
        leading: Icon(Icons.link, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          url,
          style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey[700]),
        ),
        onTap: onTap,
        trailing: Icon(Icons.open_in_new, size: 18.sp),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, {required Event event}) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main event image and details
          Stack(
            children: [
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: event.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: event.images[0].imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            size: 40.sp,
                            color: Colors.red,
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                ),
              ),

              // Event details overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      vSpacer(8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          hSpacer(4),
                          Expanded(
                            child: Text(
                              event.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Date box
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 80.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.dateDay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event.dateMonth,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        event.dateYear,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Watch event button
          InkWell(
            onTap: () {
              if (event.videoLink.isNotEmpty) {
                launchInBrowser(context, event.videoLink);
              }
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline,
                      color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Watch Event Video",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
