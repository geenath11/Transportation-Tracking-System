
import 'package:flutter/material.dart';

import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class PaymentMethodCard extends StatefulWidget {
const PaymentMethodCard({
super.key,
});

@override
State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
final TextEditingController cardNumberController =
TextEditingController();

final TextEditingController expiryController =
TextEditingController();

final TextEditingController cvvController =
TextEditingController();

@override
void dispose() {
cardNumberController.dispose();
expiryController.dispose();
cvvController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(24),
border: Border.all(
color: Colors.black12,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Payment Method',
style: AppTextStyles.semiBold.copyWith(
fontSize: 17,
),
),

const SizedBox(height: 18),

// Card number
Text(
'Card number',
style: AppTextStyles.regular.copyWith(
fontSize: 14,
color: Colors.black54,
),
),

const SizedBox(height: 6),

TextField(
controller: cardNumberController,
keyboardType: TextInputType.number,
maxLength: 19,
decoration: InputDecoration(
hintText: '1234 5678 9012 3456',
counterText: '',
prefixIcon: const Icon(
Icons.credit_card_outlined,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Colors.black12,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFF3339EC),
width: 1.5,
),
),
),
),

const SizedBox(height: 16),

// Expiration date + CVV
Row(
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Expiration date',
style: AppTextStyles.regular.copyWith(
fontSize: 14,
color: Colors.black54,
),
),

const SizedBox(height: 6),

TextField(
controller: expiryController,
keyboardType: TextInputType.number,
maxLength: 5,
decoration: InputDecoration(
hintText: 'MM/YY',
counterText: '',
prefixIcon: const Icon(
Icons.calendar_today_outlined,
size: 20,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Colors.black12,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFF3339EC),
width: 1.5,
),
),
),
),
],
),
),

const SizedBox(width: 12),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'CVV',
style: AppTextStyles.regular.copyWith(
fontSize: 14,
color: Colors.black54,
),
),

const SizedBox(height: 6),

TextField(
controller: cvvController,
keyboardType: TextInputType.number,
maxLength: 4,
obscureText: true,
decoration: InputDecoration(
hintText: '•••',
counterText: '',
prefixIcon: const Icon(
Icons.lock_outline_rounded,
size: 20,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Colors.black12,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFF3339EC),
width: 1.5,
),
),
),
),
],
),
),
],
),
],
),
);
}
}
