import 'dart:developer';

import 'package:ai_chatgpt/constants/constants.dart';
import 'package:ai_chatgpt/models/chat_model.dart';
import 'package:ai_chatgpt/providers/models_provider.dart';
import 'package:ai_chatgpt/services/api_service.dart';
import 'package:ai_chatgpt/services/services.dart';
import 'package:ai_chatgpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';

// Assets
import 'package:ai_chatgpt/services/assets_manager.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;

  late FocusNode focusNode;

  late ScrollController _listScrollCOntroller;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    _listScrollCOntroller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    _listScrollCOntroller.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("ChatGPT"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openAiLogo),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _listScrollCOntroller,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                          msgs: chatList[index].msg,
                          chatIndex: chatList[index].chatIndex);
                    },
                    itemCount: chatList.length,
                  ),
                  if (_isTyping) ...[
                    const Positioned(
                      bottom: 20,
                      // Center the child
                      left: 0,
                      right: 0,
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // if (_isTyping) ...[
            //   const SpinKitThreeBounce(
            //     color: Colors.white,
            //     size: 18,
            //   ),
            // ],
            SizedBox(
              height: 60,
              child: Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                            );
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: "How can i help you?",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await sendMessageFCT(modelsProvider: modelsProvider);
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _listScrollCOntroller.animateTo(
        _listScrollCOntroller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: msg, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList.addAll(await ApiService.sendMessage(
          msg: msg, modelId: modelsProvider.getCurrentModel));
      setState(() {});
    } catch (e) {
      // print(e);
      log(e.toString());
    } finally {
      setState(() {
        _isTyping = false;
        _scrollToBottom();
      });
    }
  }
}
