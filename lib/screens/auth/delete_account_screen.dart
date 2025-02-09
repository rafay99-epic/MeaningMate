import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meaning_mate/repositories/delete_repository.dart';
import 'package:meaning_mate/utils/image.dart';

//------------------------------------
//  Delete User Auth and Data Screen
//------------------------------------
class DeleteProfile extends StatelessWidget {
  const DeleteProfile({super.key});

  //----------------------------------
  //  Main Build Widget
  //----------------------------------
  @override
  Widget build(BuildContext context) {
    final deleteData = DeleteService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Profile"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            children: [
              const SizedBox(height: 100),
              SvgPicture.asset(
                DeleteScreenImage.logo,
                width: 150,
                height: 150,
              ),
              Text(
                'Delete Account',
                style: GoogleFonts.roboto(
                  letterSpacing: .5,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'Consequences of Deleting Your Account',
                style: GoogleFonts.roboto(
                  letterSpacing: .5,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 15),
              for (var item in [
                ' All Words will be deleted.',
                ' Your account history will be erased.',
                ' You will be logged out from all devices.',
                ' Account recovery will not be possible.'
              ])
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '• ',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              const SizedBox(height: 35),
              //----------------------------------
              //  Elevated Button
              //----------------------------------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                onPressed: () {
                  //----------------------------------
                  //  Delete Dialog Box
                  //----------------------------------
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                            'Are you sure you want to delete your account?'),
                        content: const Icon(Icons.warning,
                            color: Colors.red, size: 40),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Yes'),
                            onPressed: () => deleteData.deleteAccount(context),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.white, semanticLabel: 'Warning'),
                    const SizedBox(width: 10),
                    Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 20),
                      semanticsLabel: 'Delete Account Button',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
