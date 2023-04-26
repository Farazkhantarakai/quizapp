import 'package:flutter/material.dart';
import 'package:quiz_app/utils/colors.dart';

class SDialogue extends StatelessWidget {
  const SDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/wifi.png',
                width: 100,
                height: 100,
              ),
              const Text(
                'No Internet',
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    ));
  }
}



// Scaffold(
//         body: Center(
//           child: Container(
//             width: double.infinity,
//             height: 300,
//             color: mobileBackgroundColor,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/icons/wifi.png',
//                   width: 100,
//                   height: 100,
//                 ),
//                 const Text(
//                   'No Internet',
//                   style: TextStyle(
//                       fontFamily: 'Poppins', fontSize: 20, color: Colors.white),
//                 )
//               ],
//             ),
//           ),
//         ),