import 'package:flutter/material.dart';
import 'dart:typed_data';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback selectImage, onSend;
  final List<Uint8List> images;

  const TextFieldWidget(
      {super.key,
      required this.searchController,
      required this.selectImage,
      required this.onSend,
      required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 232, 141, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Visibility(
              visible: images.isNotEmpty,
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (context, i) => const SizedBox(
                    width: 4,
                  ),
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(images[index]),
                        ),
                      ),
                    );
                  },
                ),
              )),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: selectImage,
              ),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  maxLines: 4,
                  minLines: 1,
                  decoration: const InputDecoration(
                      hintText: "Enter a prompt here ",
                      border: InputBorder.none),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent.withOpacity(0.2),
                child:
                    IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
