import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/styling/colors.dart';

enum CustomFormFieldTypes { text, password, email }

class CustomFormField extends StatefulWidget {
  CustomFormFieldTypes type;
  final String hintText;
  final IconData icon;
  double marginBottom;
  bool isPassword;
  bool readOnly;

  TextEditingController? controller;
  List<TextFieldValidator>? validators;

  ValueChanged<String>? onChange;
  FormFieldSetter<String>? onSave;
  ValueChanged<String>? onSubmit;

  CustomFormField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.type = CustomFormFieldTypes.text,
    this.controller,
    this.validators,
    this.onChange,
    this.onSave,
    this.onSubmit,
    this.marginBottom = 22.0,
    this.isPassword = false,
    this.readOnly = false
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  /// [RequiredValidator] is the default validator in case of validators
  /// list is null, in case of validators list is given, then [MultiValidator]
  /// is used with both [defaultValidator] (as the first validator) and [widget.validators]
  TextFieldValidator defaultValidator =
  RequiredValidator(errorText: "Ce champ est obligatoire");

  /// Used to keep track of password text field state (nromal / obscure)
  bool isHiden = true;

  Widget _buildPasswordToggler() {
    return Visibility(
      visible: widget.isPassword,
      child: IconButton(
        icon: Icon(isHiden ? IconlyLight.hide : IconlyLight.show),
        color: AppColors.darkBlue.withOpacity(0.3),
        onPressed: () => setState(() {
          isHiden = !isHiden;
        }),
      ),
    );
  }

  List<TextFieldValidator> _getValidatorsFromType() {
    if (widget.type == CustomFormFieldTypes.email) {
      return [
        defaultValidator,
        EmailValidator(errorText: "Email non valide")
      ];
    }
    return [defaultValidator, ...?widget.validators];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextFormField(
            keyboardType: widget.type == CustomFormFieldTypes.email
                ? TextInputType.emailAddress
                : TextInputType.text,
            controller: widget.controller,
            onChanged: widget.onChange,
            onSaved: widget.onSave,
            onFieldSubmitted: widget.onSubmit,
            obscureText: widget.isPassword & isHiden,
            validator: MultiValidator(_getValidatorsFromType()),
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.all(16.0),
              hintStyle: TextStyle(color: AppColors.darkBlue.withOpacity(0.3)),
              fillColor: const Color(0xFFF8F7F7),
              filled: true,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDEDF3), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(
                widget.icon,
                color: AppColors.darkBlue.withOpacity(0.3),
              ),
              suffixIcon: _buildPasswordToggler(),
              prefixIconConstraints: const BoxConstraints(minWidth: 62.0),
            ),
            readOnly: widget.readOnly,
          ),
        ),
        SizedBox(height: widget.marginBottom),
      ],
    );
  }
}