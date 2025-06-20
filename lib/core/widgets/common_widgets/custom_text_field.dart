import '../../base_import.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? contentStyle;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool readOnly;
  final bool isRequired;
  final bool isShowReqMessage;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isRequired = false,
    this.isShowReqMessage = true,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.hintStyle,
    this.contentStyle,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: contentStyle ?? TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 12.sp),
        hintText: isRequired?"$hintText*":hintText,
        hintStyle: hintStyle ?? TextStyle(fontSize: 13.sp,color: Colors.grey),
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

