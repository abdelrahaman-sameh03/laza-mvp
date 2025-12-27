import 'package:flutter/material.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _ownerCtrl = TextEditingController(text: 'Mrh Raju');
  final _numberCtrl = TextEditingController(text: '5254 7634 8734 7690');
  final _expCtrl = TextEditingController(text: '24/24');
  final _cvvCtrl = TextEditingController(text: '7763');

  bool _saveCard = true;

  @override
  void dispose() {
    _ownerCtrl.dispose();
    _numberCtrl.dispose();
    _expCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _CircleIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _CardCarousel(),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add new card (UI only)')),
                    );
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: const Text(
                    'Add new card',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Card Owner', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      _Field(ctrl: _ownerCtrl, hint: 'Name'),
                      const SizedBox(height: 18),
                      const Text('Card Number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      _Field(ctrl: _numberCtrl, hint: 'Card Number', keyboardType: TextInputType.number),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('EXP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 10),
                                _Field(ctrl: _expCtrl, hint: 'MM/YY', keyboardType: TextInputType.datetime),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CVV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 10),
                                _Field(ctrl: _cvvCtrl, hint: 'CVV', keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Save card info',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Switch(
                            value: _saveCard,
                            onChanged: (v) => setState(() => _saveCard = v),
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF48C774),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.address),
                  child: const Text(
                    'Save Card',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
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

class _CardCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView(
        controller: PageController(viewportFraction: 0.86),
        children: const [
          _DemoCard(title: 'Visa Classic', name: 'Mrh Raju', last: '7690'),
          _DemoCard(title: 'Mastercard', name: 'Mrh Raju', last: '5542', muted: true),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String name;
  final String last;
  final bool muted;
  const _DemoCard({required this.title, required this.name, required this.last, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: muted ? const Color(0xFFE7F0E7) : const Color(0xFFFFD15A),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                muted ? 'MC' : 'VISA',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                const SizedBox(height: 18),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('**** **** **** $last', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 10),
                const Text('\$3,763.87', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final TextInputType? keyboardType;
  const _Field({required this.ctrl, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF2F4F8),
          ),
          child: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }
}
