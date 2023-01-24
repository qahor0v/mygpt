import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygpt/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> allMessages = [];

  getData() {
    if (controller.text.trim().isNotEmpty && controller.text.trim() != "") {
      ApiService.getResponse(controller.text.trim()).then((value) {
        log("$value");
        setState(() {
          allMessages.add({
            "fromAI": true,
            "text": "$value",
          });
          isLoading = false;
        });
      });
    }
  }

  sendMessage() {
    if (controller.text.trim().isNotEmpty && controller.text.trim() != "") {
      getData();
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
        allMessages.add({
          "fromAI": false,
          "text": controller.text.trim(),
        });
      });
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            top: 8,
            bottom: 8,
          ),
          // height: MediaQuery.of(context).size.height*0.01,
          // width: MediaQuery.of(context).size.height*0.01,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.height * 0.1),
            child: Image.asset('assets/img.png', fit: BoxFit.cover),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              setState(() {
                allMessages.clear();
              });
            },
            child: const Icon(
              CupertinoIcons.delete,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 12)
        ],
        title: const Text(
          "ChatGPT",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return message(
                  allMessages[index]['text'],
                  allMessages[index]['fromAI'],
                );
              },
              // 40 list items
              childCount: allMessages.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 6),
        height: MediaQuery.of(context).size.height * 0.064,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          cursorWidth: 5,
          maxLines: null,
          style: const TextStyle(
            color: Colors.white,
          ),
          controller: controller,
          cursorColor: Colors.green.shade800,
          decoration: InputDecoration(
            suffixIcon: isLoading
                ? const CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : GestureDetector(
                    child: Icon(
                      Icons.send,
                      color: controller.text.isEmpty
                          ? Colors.black54
                          : Colors.white,
                    ),
                    onTap: () {
                      sendMessage();
                    },
                  ),
            border: InputBorder.none,
            hintText: "Enter a message",
            hintStyle: const TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget message(String text, bool fromAI) {
    return Row(
      mainAxisAlignment:
          fromAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: fromAI ? Colors.blueGrey.shade700 : Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: fromAI
                  ? const Radius.circular(0.1)
                  : const Radius.circular(16),
              bottomRight: !fromAI
                  ? const Radius.circular(0.1)
                  : const Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: fromAI ? 20 : MediaQuery.of(context).size.width * 0.2,
            right: !fromAI ? 20 : MediaQuery.of(context).size.width * 0.2,
          ),
          child: SelectableText(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
