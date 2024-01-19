import 'package:flutter/material.dart';
import 'package:splitwise/AppConstants/constants.dart';
import 'package:splitwise/CustomWidget/Policy.dart';
import 'package:splitwise/Screen/SignUp.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255,21, 22, 23),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            trailing: Icon(Icons.input, color: Colors.white),
            title: Text('Menu', style: TextStyle(color: Colors.white)),
            onTap: () => {},
          ),
          const SizedBox(height: 20,),
          Image.asset("./logo.png", height: 50, width: 50,),
          const SizedBox(height: 50,),
          ListTile(
            leading: Icon(Icons.input, color: Colors.white),
            title: Text('Split Equal', style: TextStyle(color: Colors.white)),
            onTap: () => {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const ImageSlider(),
              //   ),
              // ),
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.white),
            title: Text('Split UnEqual', style: TextStyle(color: Colors.white)),
            onTap: () => {Navigator.of(context).pop()},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Friends', style: TextStyle(color: Colors.white)),
            onTap: () => {
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>SignUpPage()
                ),
              ),
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.border_color, color: Colors.white),
            title: Text('Terms & Condition', style: TextStyle(color: Colors.white)),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Policy(
                    heading: "Terms & Condition",
                    termstitle: AppConstant().termsTitle,
                  ),
                ),
              ),
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Privacy', style: TextStyle(color: Colors.white)),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  Policy(heading: "Privacy",termstitle: AppConstant().privacyTitle,),
                ),
              ),
            },
          ),
          const Divider(),
          const SizedBox(height: 50,),
         const Expanded(
            child: Center(
              child: Column(
                children: [
                  Text("V1.0.1", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
