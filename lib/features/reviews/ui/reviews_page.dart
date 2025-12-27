import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../data/review_model.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  static const List<ReviewModel> _mock = [
    ReviewModel(
      name: 'Jenny Wilson',
      date: '13 Sep, 2020',
      rating: 4.8,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    ReviewModel(
      name: 'Ronald Richards',
      date: '13 Sep, 2020',
      rating: 4.8,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    ReviewModel(
      name: 'Guy Hawkins',
      date: '13 Sep, 2020',
      rating: 4.8,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
    ),
    ReviewModel(
      name: 'Savannah Nguyen',
      date: '13 Sep, 2020',
      rating: 4.8,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CircleIcon(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text('Reviews',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_mock.length} Reviews',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(.8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const _Stars(rating: 4.8),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF7A59),
                        side: const BorderSide(color: Color(0xFFFF7A59)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.addReview),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Add Review',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: _mock.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (_, i) => _ReviewCard(r: _mock[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel r;
  const _ReviewCard({required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF5F6FA),
          backgroundImage: r.avatarUrl == null ? null : NetworkImage(r.avatarUrl!),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.black.withOpacity(.35)),
                            const SizedBox(width: 6),
                            Text(r.date,
                                style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      Row(
                        children: const [
                          Text('rating', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                          SizedBox(width: 8),
                          _Stars(rating: 4.8),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                r.text,
                style: const TextStyle(color: AppColors.muted, height: 1.4, fontSize: 15),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        IconData icon;
        if (i < full) {
          icon = Icons.star;
        } else if (i == full && hasHalf) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: 16, color: const Color(0xFFFFB300));
      }),
    );
  }
}
