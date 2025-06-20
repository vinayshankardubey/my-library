import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/utils.dart';
import '../../../../models/seat_booking_model.dart';

class LibraryProvider extends ChangeNotifier{
  TextEditingController seatNumberController = TextEditingController();
  TextEditingController librarySearchController = TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  bool isLoading = false;
  List<Map<String,dynamic>> _libraryDataList = [];
  List<SeatBookingModel> _totalSeats = [];
  List<Map<String,dynamic>> _studentsData = [];
  List<Map<String,dynamic>> _studentFeesDataList = [];
  Map<String,dynamic> _singleStudentData = {};


  List<SeatBookingModel> get totalSeats => _totalSeats;
  Map<String,dynamic>  get singleStudentData => _singleStudentData;
  List<Map<String,dynamic>> get studentsData => _studentsData;
  List<Map<String,dynamic>> get studentFeesDataList => _studentFeesDataList;
  List<Map<String,dynamic>>  get libraryDataList => _libraryDataList;
  Timer? _debounce;


  void update(){
    notifyListeners();
  }

  void init ({required String libraryId})async{
     await fetchStudentData(libraryId: libraryId);
  }


  ///This method is used for searching debounce
  Future<void> searchStudent({required String query,required String libraryId}) async {
         ///It cancel time which was start when this method call\
        _debounce?.cancel();
        _debounce = Timer(Duration(milliseconds: 500), () async{
          try {
            if (query
                .trim()
                .isEmpty) {
              await fetchStudentData(libraryId: libraryId);
            }
            else {
              final response = await supabaseClient.from("students").select().or(
                  'name.ilike.%$query%,mobile_number.ilike.%$query%').eq("library_id", libraryId);
              if (response != null && response.isNotEmpty) {
                _studentsData = response;
                debugPrint("Student data found $response");
              } else {
                _studentsData = [];
              }
            }
          }catch (ex) {
            debugPrint("Exception occurred while searching in student table $ex");
          }finally{
            notifyListeners();
          }
        });
  }


  Future<void> searchLibrary({required String query}) async{
    try {
       _debounce?.cancel();
       _debounce = Timer(Duration(milliseconds:300 ),() async{
         if(query.trim().isNotEmpty){
           final libraryResponse = await supabaseClient.from("library").select().ilike("name","$query%").eq("user_id", supabaseClient.auth.currentUser!.id);

           if(libraryResponse!=null && libraryResponse.isNotEmpty){
             _libraryDataList = libraryResponse;
           }else{
             _libraryDataList = [];
           }
         }else{
            await fetchLibraryData();
         }
       });

    }catch (ex){
      _libraryDataList = [];
      debugPrint("Exception occurred while searching in library Data $ex");
    }finally{
      notifyListeners();
    }
  }
  Future<void> fetchLibraryData()async{
    try{
      isLoading = true;
      notifyListeners();
      final response = await supabaseClient.from('library')
          .select().eq('user_id',supabaseClient.auth.currentUser!.id);

      if(response!=null && response.isNotEmpty){
        _libraryDataList = response;
        debugPrint("Library data found");
      }else{
        _libraryDataList = [];
        debugPrint("Library data not found");
      }
    }catch (ex){
      _libraryDataList = [];
      debugPrint("Exception Occurred while fetching library data $ex");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


  ///This method is used for creating seat for particular library
  Future<void> createSeatsForLibrary({ required String libraryId , required  int totalSeats}) async {
    List<Map<String, dynamic>> seatsData = List.generate(totalSeats, (index) {
      return {
        'library_id': libraryId,
        'seat_id':  index+1,
        'is_booked': false,
        'user_id': null,
      };
    });
    try {
      final response = await supabaseClient.from('seat_booking').insert(
          seatsData).select();
      if (response != null && response.isNotEmpty) {
        debugPrint("Seat insert successfully!");
      } else {
        debugPrint('Seats inserted failed!');
      }
    } catch (ex) {
      debugPrint("Exception occurred while creating seats $ex");
    }
  }


  ///this method is used for fetching all seat of particular library
  Future<void> fetchAllSeats({required String libraryId})async {
    try {
      final response = await supabaseClient.from('seat_booking').select().eq('library_id', libraryId).order('seat_id',ascending: true);
      if(response!=null && response.isNotEmpty){
        debugPrint("Seat fetch successful $response");
        _totalSeats = response.map((map) {
          return SeatBookingModel(
              seatId: map['seat_id'].toString(),
              isBooked: map['is_booked'],
              isSelected : false
          );
        }).toList();

      }else{
        _totalSeats = [];
        debugPrint("Seat fetch failed");

      }
    } catch (ex){
      _totalSeats = [];
      debugPrint("An exception occurred while fetching seats $ex");
    }finally {
      notifyListeners();
    }
  }

  ///This method is used for booking seat
  Future<bool> bookSeat({required String seatId , required String libraryId}) async {
    final response = await supabaseClient.from('seat_booking').update({
      'is_booked': true,
      'user_id': supabaseClient.auth.currentUser!.id,
    }).eq('seat_id', seatId).eq('is_booked', false).eq("library_id", libraryId).select();

    if(response!=null && response.isNotEmpty){
      Utils.showToast(msg:"Seat booked successfully");
      return true;
    }else{
      Utils.showToast(msg:"Seat booked failed");
      return false;
    }
  }


  ///this method is used for inserting student data
  Future<void> insertStudentData({
    required int seatId,
    required String libraryId,
    required String studentName,
    required String studentEmail,
    required String studentMobileNumber,
  }) async {
    try {
      final response = await supabaseClient
          .from('students')
          .insert(
          {
            'name': studentName,
            'email': studentEmail,
            'mobile_number': studentMobileNumber,
            'library_id': libraryId,
            'seat_id': seatId,
          }
      ).select().single();

      if (response != null && response.isNotEmpty) {
        debugPrint("Student inserted: $response");
        insertStudentFeesStatus(
            createdAt: DateTime.parse(response['created_at']),
            studentId: response['id'],
        );
      } else {
        debugPrint("Failed to insert student: $response");
      }
    } catch (e) {
      debugPrint("Exception in insertStudentData: $e");
    }
  }



  ///This method is used for fetching student data associated with seat
  Future<void> fetchStudentData({required String libraryId})async {
    try {
      final response = await supabaseClient.from('students').select().eq('library_id', libraryId);
      if(response!=null && response.isNotEmpty){
        _studentsData = response;
        debugPrint("Student data fetch successfully $response");
      }else{
        _studentsData = [];
        debugPrint("Student data fetch failed");
      }
    } catch (ex){
      _studentsData = [];
      debugPrint("Exception occurred while fetching student data $ex");
    }finally{
      notifyListeners();
    }
  }

  ///This is method is used for checking student data in students list
  Future<void> checkStudentData({required int seatId, required String libraryId}) async{
    await fetchStudentData(libraryId: libraryId);
    _singleStudentData = studentsData.firstWhere(
            (data)=> data["seat_id"] == seatId && data["library_id"] == libraryId,
        orElse: ()=> {}
    );
  }

  ///This method is used for Checking seat is booked or not
  Future<bool> checkSeatAvailability({required String seatId, required String libraryId})async {
    try {
      final response = await supabaseClient.from('seat_booking').select().eq("library_id", libraryId).eq("seat_id", seatId).maybeSingle();
      if(response!=null && response.isNotEmpty){
        if(response['is_booked']){
          return false;
        }else{
          return true;
        }
      }
      return false;
    }catch (ex){
      debugPrint("Exception occurred while checking seat availability $ex");
      return false;
    }

  }

  Future<void> fetchStudentFeeData({required String libraryId}) async {
    try {
      final now = DateTime.now();

      ///It generate all 5 month before current month
      final List<DateTime> monthList = List.generate(6, (i) {
        return DateTime(now.year, now.month - 5 + i);
      });

      final students = await supabaseClient
          .from('students')
          .select().eq("library_id", libraryId);

      List<Map<String, dynamic>> finalList = [];

      for (var student in students) {
        final String studentId = student['id'].toString();
        final createdAt = DateTime.parse(student['created_at']);


        final feeRecords = await supabaseClient
            .from('student_fees_status')
            .select()
            .eq('student_id', studentId);

        final Map<String, String> statusMap = {};
        for (var fee in feeRecords) {
          final String key = '${fee['year']}-${fee['month']}';
          statusMap[key] = (fee['status'] ?? "Unpaid").toString();
        }

        List<String> monthStatus = [];
        for (DateTime m in monthList) {
          final key = '${m.year}-${m.month}';
          if (m.isBefore(DateTime(createdAt.year, createdAt.month))) {
            monthStatus.add("N/A");
          } else {
            monthStatus.add(statusMap[key] ?? "Unpaid");
          }
        }
        finalList.add({
          "name": student['name'],
          "seat_id": student['seat_id'],
          "created_at": student['created_at'],
          "status": monthStatus,
        });
      }

      _studentFeesDataList = finalList;
    } catch (e) {
      debugPrint("Error fetching student table data: $e");
      _studentFeesDataList = [];
    } finally {
      notifyListeners();
    }
  }


  Future<void> insertStudentFeesStatus({
    required String studentId,
    required DateTime createdAt,
  }) async {
    try {
      final now = DateTime.now();
      final bookingMonth = DateTime(createdAt.year, createdAt.month);

      List<Map<String, dynamic>> feeRows = [];


      ///It generate 5 month before booking month
      for (int i = 0; i < 6; i++) {
        final monthDate = DateTime(now.year, now.month - 5 + i);
        final currentMonth = DateTime(monthDate.year, monthDate.month);

        if (currentMonth.isBefore(bookingMonth)) continue;

        feeRows.add({
          'student_id': studentId,
          'month': monthDate.month,
          'year': monthDate.year,
          'status': 'Unpaid',
        });
      }

      if (feeRows.isNotEmpty) {
        await supabaseClient.from('student_fees_status').insert(feeRows);
        debugPrint("Fee status inserted for student: $studentId");
      } else {
        debugPrint("No fee rows inserted – booking is recent.");
      }
    } catch (e) {
      debugPrint("Exception in insertStudentFeesStatus: $e");
    }
  }


  Future<void> deleteStudent({required String libraryId, required int seatId,required String studentId}) async{
    try{
         isLoading = true;
         notifyListeners();
        await supabaseClient.from("students").delete().eq("library_id", libraryId).eq("seat_id", seatId);
        await supabaseClient.from("student_fees_status").delete().eq("student_id", studentId);
        final response =   await supabaseClient.from("seat_booking").update({
            "user_id": null,
            "is_booked" : false
           }).eq("library_id", libraryId).eq("seat_id", seatId).select();

        if(response!=null && response.isNotEmpty){
          Utils.showToast(msg: "Student deleted successfully");
        }else{
          Utils.showToast(msg: "Student deleted failed");
        }
    }catch (ex){
      debugPrint("Exception is occurred $ex");
    }finally{
    isLoading = false;
    fetchStudentData(libraryId: libraryId);
    notifyListeners();
    }
  }





}


