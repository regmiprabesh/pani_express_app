import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pani_express/blocs/auth/auth_bloc.dart';
import 'package:pani_express/blocs/auth/auth_event.dart';
import 'package:pani_express/blocs/auth/auth_state.dart';
import 'package:pani_express/utils/app_routes.dart';
import 'package:pani_express/widgets/custom_button.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = '';
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpSent) {
          // Navigate to OTP verification
          Navigator.of(context).pushNamed(
            AppRoutes.otpVerification,
            arguments: {'phoneNumber': state.phoneNumber},
          );
        } else if (state.status == AuthStatus.loading) {
          // Show loading
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(localizations.loading)));
        } else if (state.errorMessage != null) {
          // Show error
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    // Logo and app name
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Welcome text
                    Text(
                      localizations.welcome,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      localizations.phoneEnterMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 50),
                    // Phone input form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: localizations.phoneNumber,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            initialCountryCode: 'NP', // Default to Nepal
                            onChanged: (phone) {
                              setState(() {
                                _completePhoneNumber = phone.completeNumber;
                                _isButtonEnabled = phone.number.length >= 7;
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Continue button
                          CustomButton(
                            text: localizations.continueTxt,
                            onPressed:
                                _isButtonEnabled ? _submitPhoneNumber : null,
                            isLoading: context.watch<AuthBloc>().state.status ==
                                AuthStatus.loading,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Terms and policy text
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          localizations.termsMessage,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitPhoneNumber() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(PhoneNumberSubmitted(_completePhoneNumber));
    }
  }
}
