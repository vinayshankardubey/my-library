import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider extends ChangeNotifier{
  final SupabaseClient supabaseClient = Supabase.instance.client;
  Map<String,dynamic> _userProfileData = {};


  Map<String,dynamic> get userProfileData => _userProfileData;


  bool isLoading = false;

  void update(){
    notifyListeners();
  }

  Future<void> init() async{
    await fetchProfileData();
  }
  Future<void> fetchProfileData()async{
    try{
      isLoading = true;
      notifyListeners();
      final response = await supabaseClient.from('users')
                           .select().eq('user_id',supabaseClient.auth.currentUser!.id).maybeSingle();

      if(response!=null && response.isNotEmpty){
        _userProfileData = response;
        debugPrint("Profile data found");
      }else{
        _userProfileData = {};
        debugPrint("Profile data not found");
      }
    }catch (ex){
      _userProfileData = {};
      debugPrint("Exception Occurred while fetching profile data $ex");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


}