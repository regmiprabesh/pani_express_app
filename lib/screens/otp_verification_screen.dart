import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pani_express/blocs/auth/auth_bloc.dart';
import 'package:pani_express/blocs/auth/auth_event.dart';
import 'package:pani_express/blocs/auth/auth_state.dart';
import 'package:pani_express/utils/app_routes.dart';
import 'package:pani_express/widgets/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpComplete = false;
  int _resendSeconds = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Navigate to dashboard for existing users
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.dashboard,
            (route) => false,
          );
        } else if (state.status == AuthStatus.newUser) {
          // Navigate to registration for new users
          Navigator.of(context).pushNamed(AppRoutes.userRegistration);
        } else if (state.status == AuthStatus.loading) {
          // Show loading
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Verifying OTP...')));
        } else if (state.errorMessage != null) {
          // Show error
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  'OTP Verification',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 16),
                // Description
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      const TextSpan(
                        text: 'We have sent a verification code to ',
                      ),
                      TextSpan(
                        text: widget.phoneNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // OTP input fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 56,
                      fieldWidth: 48,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.grey[100],
                      selectedFillColor: Colors.white,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Colors.grey[300],
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _otpController,
                    onCompleted: (v) {
                      setState(() {
                        _isOtpComplete = true;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _isOtpComplete = value.length == 6;
                      });
                    },
                    beforeTextPaste: (text) {
                      // Only allow digits
                      return text?.replaceAll(RegExp(r'[^0-9]'), '') != null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 24),
                // Resend code option
                Center(
                  child: TextButton(
                    onPressed: _resendSeconds == 0
                        ? () {
                            context.read<AuthBloc>().add(
                                  PhoneNumberSubmitted(widget.phoneNumber),
                                );
                            _startResendTimer();
                          }
                        : null,
                    child: Text(
                      _resendSeconds > 0
                          ? 'Resend code in $_resendSeconds seconds'
                          : 'Resend code',
                      style: TextStyle(
                        color: _resendSeconds > 0
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Verify button
                CustomButton(
                  text: 'Verify',
                  onPressed: _isOtpComplete ? _verifyOtp : null,
                  isLoading: context.watch<AuthBloc>().state.status ==
                      AuthStatus.loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      context.read<AuthBloc>().add(OtpSubmitted(_otpController.text));
    }
  }
}
