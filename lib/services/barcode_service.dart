import 'dart:convert';
import 'dart:developer';
import 'package:santra_seller/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/utils/api_data.dart';
import 'package:santra_seller/utils/ext.dart';

class BarcodeService {
Future<ApiResponseModel> linkBarcodes(List<String> barcodes, String sellerCode, String orderNumber) async {
  try {
    final request = http.MultipartRequest('POST', ApiData.linkordersBarCode.toUri());

    // Set headers
    request.headers.addAll(ApiData.header);

    // Add fields
    request.fields['seller_code'] = sellerCode;
    request.fields['order_number'] = orderNumber;

    // Add barcodes list as a JSON-encoded string
    final List<Map<String, String>> barcodesData = barcodes.map((e) => {"bar_code": e}).toList();
    request.fields['bar_codes'] = jsonEncode(barcodesData);

    // Send the request
    final response = await http.Response.fromStream(await request.send());

    log("Response status code: ${response.statusCode}");
    log("Response body: ${response.body}");

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          return ApiResponseModel(status: true);
        } else {
          return ApiResponseModel(status: false, errorMessage: responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        return ApiResponseModel(status: false, errorMessage: 'Empty response received');
      }
    } else {
      return ApiResponseModel(status: false, errorMessage: 'HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e, stackTrace) {
    log("Error in linkBarcodes: $e");
    log("Stack trace: $stackTrace");
    return ApiResponseModel(status: false, errorMessage: 'An unexpected error occurred: $e');
  }
}
  Future<ApiResponseModel> viewOrderBarcodes(String sellerCode, String orderNumber) async {
    try {
      Map<String, String> requestBody = {
        "seller_code": sellerCode,
        "order_number": orderNumber,
      };

      log("Request body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        ApiData.viewBarcodes.toUri(),
        headers: ApiData.header,
        body: requestBody,
      );

      log("Response status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == true) {
            return ApiResponseModel(status: true,data: responseData['data']);
          } else {
            return ApiResponseModel(status: false, errorMessage: responseData['message'] ?? 'Unknown error occurred');
          }
        } else {
          return ApiResponseModel(status: false, errorMessage: 'Empty response received');
        }
      } else {
        return ApiResponseModel(status: false, errorMessage: 'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      log("Error in viewOrderBarcodes: $e");
      log("Stack trace: $stackTrace");
      return ApiResponseModel(status: false, errorMessage: 'An unexpected error occurred: $e');
    }
  }
}