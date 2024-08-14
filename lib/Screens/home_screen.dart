import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_ai_app/Model/ai_model.dart';
import 'package:gemini_ai_app/Screens/chat_view.dart';
import 'package:gemini_ai_app/Screens/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SearchController searchController = SearchController();
  final ImagePicker imagePicker = ImagePicker();
  final gemini = Gemini.instance;
  List<AIModel> aimodel = [];
  bool isLoading = false;

  List<Uint8List>? images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Gemini App'),
        backgroundColor: const Color.fromARGB(255, 211, 57, 238),
      ),
      body: Column(
        children: [
          Expanded(
            child: Visibility(
              replacement: const Expanded(
                  child: Center(
                child: Text("Hello! How can I help you?"),
              )),
              visible: aimodel.isNotEmpty,
              child: SingleChildScrollView(
                  reverse: true,
                  child: ListView.separated(
                    itemCount: aimodel.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, i) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      return ChatViewWidget(
                        aimodel: aimodel[index],
                      );
                    },
                  )),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const SizedBox(
              height: 60,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [Colors.purple],
                  strokeWidth: 2,
                  pathBackgroundColor: Colors.purple),
            ),
          ),
          TextFieldWidget(
            searchController: searchController,
            selectImage: () async {
              final List<XFile> files = await imagePicker.pickMultiImage();
              if (files.isNotEmpty) {
                for (final img in files) {
                  images?.add(await img.readAsBytes());
                  setState(() {});
                }
              }
            },
            onSend: () {
              aimodel.add(AIModel(
                  isUser: true,
                  text: searchController.text.toString(),
                  images: images));

              String text = searchController.text.toString();
              searchController.clear();
              isLoading = true;

              List<Uint8List> img = images ?? [];
              images = [];
              setState(() {});
              gemini
                  .streamGenerateContent(
                text,
                images: img,
              )
                  .listen((value) {
                if (aimodel.last.isUser == true) {
                  aimodel.add(AIModel(
                    isUser: false,
                    text: value.output,
                    images: [],
                  ));
                }
                if (aimodel.last.text == value.output) {
                  value.output!.trim();
                } else {
                  aimodel.last.text = "${aimodel.last.text}${value.output}";
                }
                isLoading = false;

                setState(() {});
              }).onError((e) {
                log('streamGenerateContent exception', error: e);
              });
            },
            images: images ?? [],
          )
        ],
      ),
    );
  }
}
