import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/utils/colors.dart';

class CAppBar extends StatefulWidget {
  const CAppBar({super.key});

  @override
  State<CAppBar> createState() => _CAppBarState();
}

class _CAppBarState extends State<CAppBar> {
  String image = '';

  @override
  void initState() {
    super.initState();
    FirebaseService().getUserImage().then((value) {
      setState(() {
        image = value;
      });
      if (kDebugMode) {
        print('inside $image');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('i am here');
    }
    return Container(
      constraints: const BoxConstraints.expand(
        width: double.infinity,
        height: 120,
      ),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: Offset(2.0, 2.0),
                blurRadius: 10.0,
                spreadRadius: 0.0)
          ],
          color: appBarColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('I am here');
                }
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'assets/icons/menu.png',
                width: 40,
              ),
            ),
            const Text(
              'Quiz App',
              style: TextStyle(
                  fontFamily: 'Poppins', color: Colors.white, fontSize: 30),
            ),
            GestureDetector(
              onTap: () {
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [const PopupMenuItem(child: Text('LogOut'))];
                  },
                );
              },
              child: Container(
                constraints: const BoxConstraints.expand(width: 40, height: 40),
                child: CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: NetworkImage(image),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
