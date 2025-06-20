import 'package:flutter/cupertino.dart';
import 'package:mylibraryapp/models/booking_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingHistoryProvider extends ChangeNotifier {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  List<BookingHistoryModel> _bookingHistoryList = [];
  bool _isLoading = false;


  bool get isLoading => _isLoading;
  List<BookingHistoryModel> get bookingHistoryList => _bookingHistoryList;

  final List<String> monthShortNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',];


  ///This Method is used for fetching booking history
  Future<void> fetchBookingHistory() async {
    final userId = supabaseClient.auth.currentUser!.id;
    try {
      _bookingHistoryList = [];
      _isLoading = true;
      notifyListeners();
      final allLibrary = await supabaseClient.from("library").select().eq("user_id",userId);
      if (allLibrary != null && allLibrary.isNotEmpty){

             for(var library in allLibrary){
               final libraryId = library["library_id"];
               final students = await supabaseClient.from("students").select().eq("library_id", libraryId);

                 for(var student in students)
                   {
                     final studentId = student["id"];
                     final fees = await supabaseClient.from("student_fees_status").select().eq("student_id", studentId);

                     for(var fee in fees){

                       // Merge and store all histories
                       _bookingHistoryList.add(
                           BookingHistoryModel(
                               libraryName: library['name'],
                               studentName: student['name'],
                               email: student['email'],
                               mobileNumber: student['mobile_number'],
                               seat: "S${student['seat_id']}",
                               status : fee['status'],
                               month : fee['month'],
                               year : 2025,
                               paymentDate : fee['created_at'],
                               bookingDate : student['created_at'],
                           ),
                       );
                     }
                   }
             }
      }
    } catch (ex){
      debugPrint("Exception occurred while fetching booking history $ex");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}
