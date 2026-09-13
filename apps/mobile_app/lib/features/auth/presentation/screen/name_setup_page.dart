import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transportation_tracking_system/features/auth/presentation/screen/permission_setup_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class NameSetupPage extends StatefulWidget {
  const NameSetupPage({super.key});

  @override
  State<NameSetupPage> createState() => _NameSetupPageState();
}

class _NameSetupPageState extends State<NameSetupPage> {
  static final _nameFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z ]'),
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  bool _showIntroText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameFocus.addListener(_updateIntroVisibility);
    _lastNameFocus.addListener(_updateIntroVisibility);
  }

  void _updateIntroVisibility() {
    final shouldShowIntro =
        !_firstNameFocus.hasFocus && !_lastNameFocus.hasFocus;
    if (_showIntroText == shouldShowIntro) return;
    setState(() {
      _showIntroText = shouldShowIntro;
    });
  }

  Future<void> _saveUserProfile({required bool continueToNextPage}) async {
    if (_isLoading) return;
    final user = _auth.currentUser;
    if (user == null) {
      _showMessage('User session not found. Please sign in again.');
      return;
    }
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (continueToNextPage && firstName.isEmpty) {
      _showMessage('Please enter your first name');
      return;
    }
    if (continueToNextPage && lastName.isEmpty) {
      _showMessage('Please enter your last name');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': [
          firstName,
          lastName,
        ].where((name) => name.isNotEmpty).join(' '),
        'phoneNumber': user.phoneNumber,
        'role': 'passenger',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PermissionSetupPage()),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      _showMessage(e.message ?? 'Failed to save your profile');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _nameInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.person_outline),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child:TextButton(
                  onPressed: () {
                    if (_isLoading) return;

                    _saveUserProfile(
                      continueToNextPage: false,
                    );
                  },
                  child: Text(
                    'Maybe Later',
                    style: AppTextStyles.bold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Cey Go',
                      style: AppTextStyles.bold.copyWith(
                        fontSize: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Journeys, Better Connections',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _showIntroText
                          ? Column(
                              key: const ValueKey('intro'),
                              children: [
                                Text(
                                  'Let’s personalize your experience',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Add your name so we can make your\n'
                                  'journey more personal',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(key: ValueKey('empty')),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(top: _showIntroText ? 35 : 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What should we call you?',
                      style: AppTextStyles.bold.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    Text('First Name', style: AppTextStyles.bold),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      inputFormatters: [_nameFormatter],
                      textCapitalization: TextCapitalization.words,
                      decoration: _nameInputDecoration('Enter your first name'),
                    ),
                    const SizedBox(height: 15),
                    Text('Last Name', style: AppTextStyles.bold),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      inputFormatters: [_nameFormatter],
                      textCapitalization: TextCapitalization.words,
                      decoration: _nameInputDecoration('Enter your last name'),
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      height: 60,
                      width: double.infinity,
                      onPressed: () {
                        if (_isLoading) return;

                        _saveUserProfile(
                          continueToNextPage: false,
                        );
                      },
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Continue',
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 17,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
