import 'package:flutter/cupertino.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/modules/home/presenter/provider/home_provider.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/utils.dart';

class AuthProvider extends ChangeNotifier{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController  = TextEditingController();
  TextEditingController mobileNumberController  = TextEditingController();
  TextEditingController libraryAddressController = TextEditingController();
  TextEditingController libraryChargesController = TextEditingController();
  TextEditingController totalSeatController = TextEditingController();
  TextEditingController libraryNameController = TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isOwner = false;

  void update(){
    notifyListeners();
  }

  ///This method is used to sign up the user
  Future<void> signUpWithEmailAndPassword({required String email, required String password,}) async{
      try {
           _isLoading = true;
           notifyListeners();
        final response = await supabaseClient.auth.signUp(
          email: email.trim(),
          password: password.trim(),
        );
        if (response.user != null) {
          Utils.showToast(msg : 'Sign-up successful! Confirmation email sent.');
          Utils.navigateToOffAll(AppRoutes.signInView);
        } else {
          Utils.showToast(msg : AppStrings.signUpFailed);
        }
      } catch (e) {
        debugPrint('Exception Occurred while user signup: $e');
      }finally{
        _isLoading = false;
        notifyListeners();
      }
  }

  ///This method is used to sign in the user
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async{
      try {
        _isLoading = true;
        notifyListeners();
        final response = await supabaseClient.auth.signInWithPassword(
          email: email.trim(),
          password: password.trim(),
        );
        final user = response.user;
        if (user != null) {
         Utils.showToast(msg : AppStrings.loginSuccessful);
          await checkUserExistence();
        } else {
          Utils.showToast(msg : AppStrings.loginFailed);
        }
      } on AuthException catch (ex){
        Utils.showToast(msg : ex.message);
      } catch (e) {
         debugPrint("An Exception occurred while login : $e");
      }finally{
        _isLoading = false;
        notifyListeners();
      }
  }


  Future<void> insertUserProfileData()async{
    try {
      final response = await supabaseClient.from('users').insert({
        'user_id': supabaseClient.auth.currentUser!.id,
        'name': nameController.text,
        'email': emailController.text.trim(),
        'mobile_number': mobileNumberController.text.trim(),
        'role': roleController.text.trim(),
      }).select();
      if(response!=null && response.isNotEmpty){
        debugPrint("Profile data inserted successfully");
      }else{
        debugPrint("Profile data insertion failed");
      }
    } catch (ex){
      debugPrint("Exception Occurred $ex");
    }
  }

  Future<void> insertLibraryData({ LibraryProvider? libraryProvider, required String ownerName, })async{
    try {
       _isLoading = true;
         notifyListeners();
      final response = await supabaseClient.from('library').insert({
        'user_id': supabaseClient.auth.currentUser!.id,
        'name': libraryNameController.text,
        'address': libraryAddressController.text.trim(),
        'charges': libraryChargesController.text,
        'owner_name': ownerName,
        'owner_number': mobileNumberController.text.trim(),
        'available_seat': int.parse(totalSeatController.text.trim()),
      }).select().single();
      if(response!=null && response.isNotEmpty){
        debugPrint("Library data inserted successfully");
          if(libraryProvider!=null){
            await  libraryProvider.createSeatsForLibrary(
                libraryId: response['library_id'].toString(),
                totalSeats: int.parse(totalSeatController.text.trim())
            );
          }
          clearControllers();
          Utils.navigateToOffAll(AppRoutes.bottomNavBar);
      }else{
        debugPrint("Library  data insertion failed");
      }
    } catch (ex){
      debugPrint("Exception Occurred $ex");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> checkUserExistence () async{
    try {
      final response = await supabaseClient.from("users").select().eq("user_id",supabaseClient.auth.currentUser!.id);
      if(response!=null && response.isNotEmpty){
        Utils.navigateToOffAll(AppRoutes.bottomNavBar);
      }else{
        Utils.navigateToOffAll(AppRoutes.addDetailsView);
      }
    }catch (ex){
      debugPrint("Exception occurred while login $ex");
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number cannot be empty';
    }

    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  void clearControllers(){
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    roleController.clear();
    mobileNumberController.clear();
    libraryChargesController.clear();
    libraryNameController.clear();
    totalSeatController.clear();
    libraryAddressController.clear();
  }

}