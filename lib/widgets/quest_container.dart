import 'package:flutter/material.dart';
import 'package:quiz_app/utils/colors.dart';

class QuestContainer extends StatefulWidget {
  QuestContainer(
      {super.key,
      required this.indication,
      required this.answer,
      required this.cColor,
      required this.function});

  final String indication;
  final String answer;
  bool cColor;
  Function function;

  @override
  State<QuestContainer> createState() => _QuestContainerState();
}

class _QuestContainerState extends State<QuestContainer> {
  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   print('inside quest container $cColor');
    // }
    return Container(
      margin: const EdgeInsets.only(top: 7, bottom: 5),
      padding: const EdgeInsets.only(left: 10),
      constraints:
          const BoxConstraints.expand(width: double.infinity, height: 50),
      decoration: BoxDecoration(
          color: !widget.cColor ? Colors.white : dataBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: dataBackgroundColor, shape: BoxShape.circle),
              child: Center(
                  child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.indication,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 7,
            child: Text(
              widget.answer,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          widget.cColor
              ? Expanded(
                  flex: 2,
                  child: IconButton(
                      onPressed: () => widget.function(false),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                )
              : Container()
        ],
      ),
    );
  }
}
