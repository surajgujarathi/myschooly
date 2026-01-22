import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myschooly/src/utils/extensions.dart';

enum MSFormFieldType {
  email,
  password,
  confirmPassword,
  username,
  fullName,
  firstName,
  lastName,
  phoneNumber,
  rollNumber, // school-specific
  admissionNumber, // school-specific
  classGrade, // e.g. "10-A"
  dateOfBirth,
  address,
  custom,
}

class MSFormField extends StatefulWidget {
  final MSFormFieldType? type; // ← new: main feature
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText; // override
  final String? hintText; // override
  final String? helperText;
  final String? errorText; // manual override
  final IconData? prefixIcon; // override
  final IconData? suffixIcon; // override
  final bool obscureText; // base value (auto-managed for password types)
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType; // override
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters; // override
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator; // override
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final bool showCounter;

  // For confirmPassword type
  final String? passwordToMatch;

  const MSFormField({
    super.key,
    this.type,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.validator,
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.showCounter = false,
    this.passwordToMatch,
  });

  @override
  State<MSFormField> createState() => _MSFormFieldState();
}

class _MSFormFieldState extends State<MSFormField> {
  late bool _obscureText;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || _isPasswordType;
  }

  bool get _isPasswordType =>
      widget.type == MSFormFieldType.password ||
      widget.type == MSFormFieldType.confirmPassword;

  String _getDefaultLabel(BuildContext context) {
    if (widget.labelText != null) return widget.labelText!;

    return switch (widget.type) {
      MSFormFieldType.email => 'Email',
      MSFormFieldType.password => 'Password',
      MSFormFieldType.confirmPassword => 'Confirm Password',
      MSFormFieldType.username => 'Username',
      MSFormFieldType.fullName => 'Full Name',
      MSFormFieldType.firstName => 'First Name',
      MSFormFieldType.lastName => 'Last Name',
      MSFormFieldType.phoneNumber => 'Phone Number',
      MSFormFieldType.rollNumber => 'Roll Number',
      MSFormFieldType.admissionNumber => 'Admission Number',
      MSFormFieldType.classGrade => 'Class / Grade',
      MSFormFieldType.dateOfBirth => 'Date of Birth',
      MSFormFieldType.address => 'Address',
      MSFormFieldType.custom || null => widget.hintText ?? 'Enter value',
    };
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${_getDefaultLabel(context)} is required';
    }

    switch (widget.type) {
      case MSFormFieldType.email:
        if (!value.trim().isValidEmail) return 'Enter a valid email';
        break;

      case MSFormFieldType.phoneNumber:
        if (!value.isValidPhone) return 'Enter a valid phone number';
        break;

      case MSFormFieldType.password:
        if (!value.isValidPassword) {
          return 'Password must be 8+ chars with letter & number';
        }
        break;

      case MSFormFieldType.confirmPassword:
        if (value != widget.passwordToMatch) return 'Passwords do not match';
        break;

      case MSFormFieldType.fullName:
      case MSFormFieldType.firstName:
      case MSFormFieldType.lastName:
      case MSFormFieldType.username:
        if (!value.isValidName) return 'Only letters and spaces allowed';
        break;

      default:
        break;
    }

    return null;
  }

  TextInputType _getDefaultKeyboard() {
    return switch (widget.type) {
      MSFormFieldType.email => TextInputType.emailAddress,
      MSFormFieldType.phoneNumber => TextInputType.phone,
      MSFormFieldType.password ||
      MSFormFieldType.confirmPassword => TextInputType.visiblePassword,
      MSFormFieldType.dateOfBirth => TextInputType.datetime,
      _ => TextInputType.text,
    };
  }

  List<TextInputFormatter> _getDefaultFormatters() {
    return switch (widget.type) {
      MSFormFieldType.phoneNumber => [FilteringTextInputFormatter.digitsOnly],
      MSFormFieldType.fullName ||
      MSFormFieldType.firstName ||
      MSFormFieldType.lastName => [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
      _ => [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveLabel = _getDefaultLabel(context);
    final effectiveValidator = widget.validator ?? _defaultValidator;
    final effectiveKeyboard = widget.keyboardType ?? _getDefaultKeyboard();
    final effectiveFormatters =
        widget.inputFormatters ?? _getDefaultFormatters();

    return Focus(
      onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hasFocus
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: effectiveKeyboard,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: effectiveFormatters,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onSaved: widget.onSaved,
          validator: effectiveValidator,
          autovalidateMode: widget.autovalidateMode,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled ? null : theme.disabledColor,
          ),
          decoration: InputDecoration(
            labelText: effectiveLabel,
            hintText: widget.hintText ?? effectiveLabel,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _hasFocus ? colorScheme.primary : null,
                  )
                : _defaultPrefixIcon(),
            suffixIcon: _buildSuffixIcon(context),
            counterText: widget.showCounter ? null : "",
            filled: true,
            fillColor: widget.readOnly || !widget.enabled
                ? colorScheme.surfaceContainerHighest.withOpacity(0.6)
                : colorScheme.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.6),
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1.8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 2.4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Icon? _defaultPrefixIcon() {
    return switch (widget.type) {
      MSFormFieldType.email => const Icon(Icons.email_outlined),
      MSFormFieldType.password ||
      MSFormFieldType.confirmPassword => const Icon(Icons.lock_outline_rounded),
      MSFormFieldType.phoneNumber => const Icon(Icons.phone_outlined),
      MSFormFieldType.dateOfBirth => const Icon(Icons.calendar_today_outlined),
      MSFormFieldType.address => const Icon(Icons.location_on_outlined),
      _ => null,
    };
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.suffixIcon != null) return Icon(widget.suffixIcon);

    if (_isPasswordType) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
        splashRadius: 20,
      );
    }
    return null;
  }
}
