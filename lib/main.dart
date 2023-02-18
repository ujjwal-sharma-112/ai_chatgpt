import 'package:ai_chatgpt/providers/models_provider.dart';
import 'package:ai_chatgpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';

// Constants
import 'package:ai_chatgpt/constants/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
