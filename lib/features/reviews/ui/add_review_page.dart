import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  double _rating = 3.0;

  @override
  void dispose() {
    _nameController.dispose();
    _textController.dispose();
    super.dispose();
  }

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
              _TopBar(
                title: 'Add Review',
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 18),

              const Text('Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _Input(
                controller: _nameController,
                hint: 'Type your name',
              ),
              const SizedBox(height: 18),

              const Text('How was your experience ?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _Input(
                controller: _textController,
                hint: 'Describe your experience?',
                maxLines: 7,
              ),
              const SizedBox(height: 18),

              const Text('Star', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 6),
                  const Text('0.0'),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 50,
                      onChanged: (v) => setState(() => _rating = v),
                    ),
                  ),
                  Text(_rating.toStringAsFixed(1)),
                  const SizedBox(width: 6),
                ],
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // UI-only for now.
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted (demo).')),
                    );
                  },
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(icon: Icons.arrow_back, onTap: onBack),
        const Spacer(),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const Spacer(),
        const SizedBox(width: 44),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _Input({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}
