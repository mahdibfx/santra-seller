class ApiResponseModel{
   bool status;
   dynamic data ; 
   String? errorMessage ;

  ApiResponseModel({  this.data,  this.errorMessage,required this.status}); 
@override
  String toString() {
    // TODO: implement toString
    return "| Status => $status | error : => $errorMessage | data : => $data ";

  }

  
}