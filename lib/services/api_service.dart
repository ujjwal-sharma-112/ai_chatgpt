import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:ai_chatgpt/constants/api_constants.dart";
import "package:ai_chatgpt/models/chat_model.dart";
import "package:ai_chatgpt/models/models_model.dart";
import "package:http/http.dart" as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$base_url/models"),
        headers: {
          'Authorization': 'Bearer $api_key',
        },
      );
      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        // print("Error: ${jsonResponse["error"]["message"]}");
        log("Error: ${jsonResponse["error"]["message"]}");
        throw HttpException("Error: ${jsonResponse["error"]["message"]}");
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        log("i: ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      // print(e);
      log("Error : $e");
      rethrow;
    }
  }

  // Chats

  static Future<List<ChatModel>> sendMessage(
      {required String msg, required String modelId}) async {
    try {
      var response = await http.post(Uri.parse("$base_url/completions"),
          headers: {
            'Authorization': 'Bearer $api_key',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "model": modelId,
            "prompt": msg,
            "max_tokens": 1000,
          }));
      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        // print("Error: ${jsonResponse["error"]["message"]}");
        // log("Error: ${jsonResponse["error"]["message"]}");
        throw HttpException("Error: ${jsonResponse["error"]["message"]}");
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse: ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(jsonResponse["choices"].length, (index) {
          return ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          );
        });
      }
      return chatList;
    } catch (e) {
      // print(e);
      // log("Error : $e");
      rethrow;
    }
  }
}
