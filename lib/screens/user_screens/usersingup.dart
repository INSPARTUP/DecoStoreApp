import 'package:deco_store_app/providers/auth.dart';
import 'package:deco_store_app/services/authservice.dart';
import 'package:deco_store_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class SingupScreen extends StatefulWidget {
  @override
  _SingupScreenState createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  var prenom, nom, numtel, email, password, confirm_password, token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Créer un compte'),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Color(0xFFFAFBFD),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            //  height: SizeConfig.height(53.9),
            color: Color(0xFFFAFBFD),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kagu',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue[800],
                    ),
                  ),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.blue[800],
                    size: 50,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  //     height: SizeConfig.height(377.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: new Form(
                          key: _key,
                          autovalidate: _validate,
                          child: FormUI(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
            obscureText: false,
            decoration: InputDecoration(
              icon: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.blue[800],
              ),
              hintText: 'Nom',
            ),
            //  maxLength: 32,
            validator: validateNom,
            onSaved: (String val) {
              nom = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
            obscureText: false,
            decoration: InputDecoration(
              icon: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.blue[800],
              ),
              hintText: 'Prenom',
            ),
            validator: validatePrenom,
            onSaved: (String val) {
              prenom = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.mail,
                  color: Colors.blue[800],
                ),
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              //    maxLength: 32,
              validator: validateEmail,
              onSaved: (String val) {
                email = val;
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
              obscureText: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone_android,
                  color: Colors.blue[800],
                ),
                hintText: '+213 55 24 97 02 1',
              ),
              maxLength: 10,
              validator: validateMobile,
              onSaved: (String val) {
                numtel = val;
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
            obscureText: true,
            validator: validatePassword,
            decoration: InputDecoration(
              icon: Icon(
                Icons.vpn_key,
                color: Colors.blue[800],
              ),
              hintText: 'Mot de passe',
            ),
            onSaved: (val) {
              password = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: TextFormField(
            obscureText: true,
            validator: validateConfirmPassword,
            decoration: InputDecoration(
              icon: Icon(
                Icons.vpn_key,
                color: Colors.blue[800],
              ),
              hintText: 'Confirmez le mot de passe',
            ),
            onSaved: (val) {
              confirm_password = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: CustomButton(
            label: 'Inscrivez-Vous',
            labelColour: Colors.white,
            backgroundColour: Colors.blue[800],
            shadowColour: Color(0xff866DC9).withOpacity(0.16),
            onPressed: _sendToServer,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  String validateNom(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Le nom est obligatoire";
    } else if (!regExp.hasMatch(value)) {
      return "Le nom doit être a-z et A-Z";
    }
    return null;
  }

  String validatePrenom(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Le prenom est obligatoire";
    } else if (!regExp.hasMatch(value)) {
      return "Le prenom doit être a-z et A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Le numero Telephone est obligatoire";
    } else if (value.length != 10) {
      return "Le numéro de telephone doit être composé de 10 chiffres";
    } else if (!regExp.hasMatch(value)) {
      return "Le numéro de telephone doit être composé de chiffres";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email est Obligatoire";
    } else if (!regExp.hasMatch(value)) {
      return " Email n'est pas valide";
    } else {
      return null;
    }
  }

  var conf;
  String validatePassword(String value) {
    if (value.length < 8) {
      conf = value;
      return "Le mot de passe doit contenir au moins 8 caractères";
    }
    conf = value;

    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.length == 0) {
      return "Le mot de passe est obligatoire";
    } else if (value != conf) {
      return "Le mot de passe est incorrect";
    }
    return null;
  }
/*


  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Name $nom");
      print("Mobile $numtel");
      print("Email $prenom");
      UserAuthService()
          .addUser(nom, prenom, numtel, email, password,)
          .then((val) {
        Fluttertoast.showToast(
            msg: val.data['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        if (val.data['success']) {
          Navigator.of(context).pushNamed('/user-login');
        }
      });
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

*/

  Future<void> _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Name $nom");
      print("Mobile $numtel");
      print("Email $prenom");

      await Provider.of<Auth>(context, listen: false).addUser(
        nom,
        prenom,
        numtel,
        email,
        password,
      );

      final inscri = Provider.of<Auth>(context, listen: false).inscription;
      print(inscri);

      if (inscri == true) {
        Navigator.of(context).pushNamed('/login');
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}
