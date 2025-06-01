import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../../domain/entity/review.dart';
import '../bloc/bloc/reviews_bloc.dart';
import '../bloc/event/reviews_event.dart';
import '../bloc/state/reviews_state.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String selectedFilter = 'All'; // All, Driver, Rider

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBackgroundColor,
      appBar: appBar(heading: 'Reviews'),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: ThemeColors.progressIndicatorColor,
                    strokeWidth: 3.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading reviews...',
                    style: AppFonts.bodyTextStyle.copyWith(
                      fontSize: AppFonts.body2TextSize,
                      color: ThemeColors.captionTextColor,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ReviewLoadedState) {
            return _buildReviewContent(state.reviewResponse);
          } else if (state is ReviewErrorState) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(24.w),
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 48.w,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Something went wrong',
                      style: AppFonts.headlineTextStyle.copyWith(
                        fontSize: AppFonts.headline3TextSize,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.headlinesTextColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.message,
                      style: AppFonts.bodyTextStyle.copyWith(
                        fontSize: AppFonts.body2TextSize,
                        color: ThemeColors.captionTextColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReviewContent(ReviewResponseEntity reviewResponse) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16.h),

          // Two Rating Cards Side by Side
          _buildRatingCards(reviewResponse),

          SizedBox(height: 24.h),

          // Filter Dropdown and Rating Breakdown
          _buildFilterAndBreakdown(reviewResponse),

          SizedBox(height: 16.h),

          // Reviews List
          _buildFilteredReviewsList(reviewResponse),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildRatingCards(ReviewResponseEntity reviewResponse) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Driver Rating Card
          Expanded(
            child: _buildRatingCard(
              'Driver',
              reviewResponse.userRatings.asDriver,
              reviewResponse.receivedAsDriver.totalReviews,
              Icons.drive_eta_rounded,
              const Color(0xFF3B82F6),
            ),
          ),
          SizedBox(width: 12.w),
          // Rider Rating Card
          Expanded(
            child: _buildRatingCard(
              'Rider',
              reviewResponse.userRatings.asRider,
              reviewResponse.receivedAsRider.totalReviews,
              Icons.person_rounded,
              const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(String title, double rating, int totalReviews,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.w,
              color: color,
            ),
          ),
          SizedBox(height: 12.h),

          // Title
          Text(
            title,
            style: AppFonts.bodyTextStyle.copyWith(
              fontSize: AppFonts.body2TextSize,
              fontWeight: FontWeight.w500,
              color: ThemeColors.captionTextColor,
            ),
          ),
          SizedBox(height: 8.h),

          // Rating
          Text(
            rating.toStringAsFixed(1),
            style: AppFonts.headlineTextStyle.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),

          // Stars
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) => Icon(
              Icons.star_rounded,
              color: color,
            ),
            itemCount: 5,
            itemSize: 16.w,
            direction: Axis.horizontal,
          ),
          SizedBox(height: 8.h),

          // Review count
          Text(
            '$totalReviews Reviews',
            style: AppFonts.bodyTextStyle.copyWith(
              fontSize: AppFonts.body3TextSize,
              color: ThemeColors.captionTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndBreakdown(ReviewResponseEntity reviewResponse) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading and Filter Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Appealing heading
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeColors.primaryColor.withOpacity(0.1),
                          ThemeColors.primaryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 20.w,
                      color: ThemeColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Overview',
                    style: AppFonts.headlineTextStyle.copyWith(
                      fontSize: AppFonts.headline4TextSize,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.headlinesTextColor,
                    ),
                  ),
                ],
              ),

              // Compact dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeColors.scaffoldBackgroundColor.withOpacity(0.3),
                  border: Border.all(
                      color: ThemeColors.dividerColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    isDense: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: ThemeColors.primaryColor,
                      size: 18.w,
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    elevation: 8,
                    items: ['All', 'Driver', 'Rider'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                value == 'Driver'
                                    ? Icons.drive_eta_rounded
                                    : value == 'Rider'
                                        ? Icons.person_rounded
                                        : Icons.star_rounded,
                                size: 16.w,
                                color: value == 'Driver'
                                    ? const Color(0xFF3B82F6)
                                    : value == 'Rider'
                                        ? const Color(0xFF10B981)
                                        : ThemeColors.primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                value,
                                style: AppFonts.bodyTextStyle.copyWith(
                                  fontSize: AppFonts.body2TextSize,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.bodyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilter = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Rating Breakdown
          _buildRatingBreakdown(reviewResponse),
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown(ReviewResponseEntity reviewResponse) {
    Map<String, int> combinedRatings;
    int totalReviews;

    if (selectedFilter == 'Driver') {
      final summary = reviewResponse.receivedAsDriver;
      combinedRatings = {
        '5': summary.fiveStar,
        '4': summary.fourStar,
        '3': summary.threeStar,
        '2': summary.twoStar,
        '1': summary.oneStar,
      };
      totalReviews = summary.totalReviews;
    } else if (selectedFilter == 'Rider') {
      final summary = reviewResponse.receivedAsRider;
      combinedRatings = {
        '5': summary.fiveStar,
        '4': summary.fourStar,
        '3': summary.threeStar,
        '2': summary.twoStar,
        '1': summary.oneStar,
      };
      totalReviews = summary.totalReviews;
    } else {
      // For 'All' - combine both driver and rider counts
      final driverSummary = reviewResponse.receivedAsDriver;
      final riderSummary = reviewResponse.receivedAsRider;

      combinedRatings = {
        '5': driverSummary.fiveStar + riderSummary.fiveStar,
        '4': driverSummary.fourStar + riderSummary.fourStar,
        '3': driverSummary.threeStar + riderSummary.threeStar,
        '2': driverSummary.twoStar + riderSummary.twoStar,
        '1': driverSummary.oneStar + riderSummary.oneStar,
      };
      totalReviews = driverSummary.totalReviews + riderSummary.totalReviews;
    }

    final ratings = [
      {
        'stars': 5,
        'count': combinedRatings['5']!,
        'color': const Color(0xFF10B981)
      },
      {
        'stars': 4,
        'count': combinedRatings['4']!,
        'color': const Color(0xFF84CC16)
      },
      {
        'stars': 3,
        'count': combinedRatings['3']!,
        'color': const Color(0xFFF59E0B)
      },
      {
        'stars': 2,
        'count': combinedRatings['2']!,
        'color': const Color(0xFFF97316)
      },
      {
        'stars': 1,
        'count': combinedRatings['1']!,
        'color': const Color(0xFFEF4444)
      },
    ];

    return Column(
      children: ratings.map((rating) {
        final percentage =
            totalReviews > 0 ? (rating['count'] as int) / totalReviews : 0.0;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              // Star number
              SizedBox(
                width: 16.w,
                child: Text(
                  '${rating['stars']}',
                  style: AppFonts.bodyTextStyle.copyWith(
                    fontSize: AppFonts.body2TextSize,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.headlinesTextColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Single star icon
              Icon(
                Icons.star_rounded,
                size: 16.w,
                color: rating['color'] as Color,
              ),
              SizedBox(width: 12.w),

              // Progress bar
              Expanded(
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: ThemeColors.dividerColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            rating['color'] as Color,
                            (rating['color'] as Color).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilteredReviewsList(ReviewResponseEntity reviewResponse) {
    List<ReviewEntity> reviews;

    if (selectedFilter == 'Driver') {
      reviews = reviewResponse.receivedAsDriver.allReviews;
    } else if (selectedFilter == 'Rider') {
      reviews = reviewResponse.receivedAsRider.allReviews;
    } else {
      // For 'All' - combine both
      reviews = [
        ...reviewResponse.receivedAsDriver.allReviews,
        ...reviewResponse.receivedAsRider.allReviews,
      ];
    }

    if (reviews.isEmpty) {
      return _buildEmptyReviews();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(ReviewEntity review) {
    return Container(
      padding: EdgeInsets.all(12.w), // Reduced from 20.w to 12.w
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Enhanced Profile Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InitialsCircleAvatar(
                  initials: _getInitials(review.name),
                  radius: 20.r, // Reduced from 24.r to 20.r
                  showCameraIcon: false,
                ),
              ),
              SizedBox(width: 12.w), // Reduced from 16.w to 12.w

              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.name,
                            style: AppFonts.headlineTextStyle.copyWith(
                              fontSize: AppFonts.headline4TextSize,
                              fontWeight: FontWeight.w600,
                              color: ThemeColors.headlinesTextColor,
                            ),
                          ),
                        ),
                        Text(
                          '${review.daysAgo.toString()} days ago',
                          style: AppFonts.headlineTextStyle.copyWith(
                            fontSize: AppFonts.captionTextSize,
                            // fontWeight: FontWeight.w600,
                            color: ThemeColors.headlinesTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h), // Reduced from 4.h to 2.h
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: review.rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: ThemeColors.primaryColor,
                          ),
                          itemCount: 5,
                          itemSize: 14.w, // Reduced from 16.w to 14.w
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 6.w), // Reduced from 8.w to 6.w
                        Text(
                          review.rating.toString(),
                          style: AppFonts.bodyTextStyle.copyWith(
                            fontSize: AppFonts.body3TextSize,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.captionTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 10.h), // Reduced from 16.h to 10.h
            Container(
              padding: EdgeInsets.all(4.w), // Reduced from 16.w to 12.w
              decoration: BoxDecoration(
                color: ThemeColors.scaffoldBackgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ThemeColors.dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                review.comment,
                style: AppFonts.bodyTextStyle.copyWith(
                  fontSize: AppFonts.body2TextSize,
                  color: ThemeColors.bodyTextColor,
                  height: 1.4, // Reduced from 1.6 to 1.4
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(48.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: ThemeColors.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_rounded,
              size: 48.w,
              color: ThemeColors.captionTextColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No reviews yet',
            style: AppFonts.headlineTextStyle.copyWith(
              fontSize: AppFonts.headline3TextSize,
              fontWeight: FontWeight.w600,
              color: ThemeColors.headlinesTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            selectedFilter == 'All'
                ? 'Reviews will appear here'
                : 'No reviews as ${selectedFilter.toLowerCase()} yet',
            style: AppFonts.bodyTextStyle.copyWith(
              fontSize: AppFonts.body2TextSize,
              color: ThemeColors.captionTextColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final names = name.split(' ');
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }
}
