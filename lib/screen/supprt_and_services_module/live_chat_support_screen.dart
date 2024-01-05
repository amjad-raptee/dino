import 'package:dino/component/appbar.dart';
import 'package:dino/component/style.dart';
import 'package:dino/constant/clr.dart';
import 'package:dino/models/live_chat_support_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LiveChatSupportScreen extends StatefulWidget {
  const LiveChatSupportScreen({super.key});

  @override
  State<LiveChatSupportScreen> createState() => _LiveChatSupportScreenState();
}

class _LiveChatSupportScreenState extends State<LiveChatSupportScreen> {
  TextEditingController _msgController = TextEditingController();
  ScrollController _msgScrollController = ScrollController();
  List<LiveChatSupportDataModel> chatData = [
    LiveChatSupportDataModel(
        time: "2024-01-05 11:36:40.972",
        sendByYou: true,
        msg: "Hi I need help to buy a bike."),
    LiveChatSupportDataModel(
        time: "2024-01-05 11:36:40.972",
        sendByYou: false,
        msg: "Hi I need help to buy a bike."),
    LiveChatSupportDataModel(
        time: "2024-01-05 14:36:40.972",
        sendByYou: true,
        msg: "Hi I need help to buy a bike."),
  ];
  @override
  Widget build(BuildContext context) {
    if (_msgScrollController.hasClients) {
      _msgScrollController
          .jumpTo(_msgScrollController.position.maxScrollExtent);
    }
    return Scaffold(
      appBar: appBar(context, "Live Chat"),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Clr.teal.withOpacity(0.1), Clr.black])),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 100),
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: chatData.length,
              controller: _msgScrollController,
              itemBuilder: (context, index) {
                bool isAm = true;
                var hour = DateTime.parse(chatData[index].time).hour;
                var minute = DateTime.parse(chatData[index].time).minute;

                if (hour > 11) {
                  hour -= 12;
                  isAm = false;
                }
                String time = "$hour:$minute ${isAm ? "am" : "pm"}";

                return chatMessageUI(context,
                    sendByYou: chatData[index].sendByYou,
                    time: time,
                    msg: chatData[index].msg);
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 7),
                  color: Clr.black1,
                  child: TextFormField(
                    controller: _msgController,
                    maxLines: 5,
                    minLines: 1,
                    cursorColor: Clr.teal,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                )),
                IconButton(
                    onPressed: () {
                      chatData.add(LiveChatSupportDataModel(
                          time: DateTime.now().toString(),
                          sendByYou: true,
                          msg: _msgController.text.trim()));

                      _msgController.clear();

                      setState(() {});
                      if (_msgScrollController.hasClients) {
                        _msgScrollController.jumpTo(
                            _msgScrollController.position.maxScrollExtent);
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_up_circle,
                      color: Clr.teal,
                      size: 40,
                    ))
              ],
            ),
          ),
        )
      ]),
    );
  }

  Column chatMessageUI(
    BuildContext context, {
    required bool sendByYou,
    required String time,
    required String msg,
  }) {
    return Column(
        crossAxisAlignment:
            !sendByYou ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(
              top: 10,
              right: !sendByYou ? MediaQuery.of(context).size.width * .2 : 0,
              left: sendByYou ? MediaQuery.of(context).size.width * .2 : 0,
            ),
            // height: 100,
            decoration: BoxDecoration(
                color: !sendByYou ? Clr.grey1 : Clr.teal2,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sendByYou ? "You" : "Raptee",
                    style: Style.fadeTextStyle(
                        fontSize: 14,
                        color: !sendByYou ? Clr.teal2 : Clr.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    msg,
                    style: Style.fadeTextStyle(color: Clr.white),
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 3),
            child: Text(
              time,
              style: Style.fadeTextStyle(fontSize: 10, color: Clr.white),
            ),
          ),
        ]);
  }
}
