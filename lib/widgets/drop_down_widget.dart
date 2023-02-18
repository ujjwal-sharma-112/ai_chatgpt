import 'package:ai_chatgpt/constants/constants.dart';
import 'package:ai_chatgpt/models/models_model.dart';
import 'package:ai_chatgpt/providers/models_provider.dart';
import 'package:ai_chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelIsDropDownWidget extends StatefulWidget {
  const ModelIsDropDownWidget({super.key});

  @override
  State<ModelIsDropDownWidget> createState() => _ModelIsDropDownWidgetState();
}

class _ModelIsDropDownWidgetState extends State<ModelIsDropDownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.currentModel;

    return FutureBuilder<List<ModelsModel>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FittedBox(
            child: DropdownButton(
              dropdownColor: scaffoldBackgroundColor,
              iconEnabledColor: Colors.white,
              items: List<DropdownMenuItem<String>>.generate(
                snapshot.data!.length,
                (index) => DropdownMenuItem(
                  value: snapshot.data![index].id,
                  child: TextWidget(
                    label: snapshot.data![index].id,
                    fontSize: 15,
                  ),
                ),
              ),
              value: currentModel,
              onChanged: (value) {
                setState(() {
                  currentModel = value.toString();
                });
                modelsProvider.setCurrentModel(value.toString());
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}


// DropdownButton(
//       dropdownColor: scaffoldBackgroundColor,
//       iconEnabledColor: Colors.white,
//       items: getModelsItem,
//       value: currentModel,
//       onChanged: (value) {
//         setState(() {
//           currentModel = value.toString();
//         });
//       },
//     );