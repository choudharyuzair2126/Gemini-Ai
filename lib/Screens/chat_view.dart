import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai_app/Model/ai_model.dart';

class ChatViewWidget extends StatelessWidget {
  final AIModel aimodel;

  const ChatViewWidget({super.key, required this.aimodel});

  @override
  Widget build(BuildContext context) {
    if (aimodel.isUser == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              child: Image(image: AssetImage('assets/user.png')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 5, left: 9, right: 9, bottom: 9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(168, 233, 128, 252)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: aimodel.images?.isNotEmpty ?? false,
                        child: SizedBox(
                          height: 100,
                          child: ListView.separated(
                            separatorBuilder: (context, i) => const SizedBox(
                              width: 4,
                            ),
                            itemCount: aimodel.images?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            reverse: false,
                            padding: const EdgeInsets.only(top: 8),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                height: 128,
                                width: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(aimodel.images![index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .80,
                            child: Text(
                              aimodel.text.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: CircleAvatar(
              child: Image(
                image: AssetImage('assets/hi.png'),
              ),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Markdown(
                selectable: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data: aimodel.text.toString(),
              )),
        ],
      );
    }
  }
}
