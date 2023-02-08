import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';
import '../widgets/profile_image.dart';
import '../widgets/widgets.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        //physics: const BouncingScrollPhysics(),
        child: MainBackground(
          child: Column(
            children: [
              const MainTopBlackBox(child: Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 25))),

              MainBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 25),
                    Center(child: ProfileImage(height: 130, width: 130)),
                    SizedBox(height: 40),
                    _ProfileData(),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}


// Profile information
class _ProfileData extends StatelessWidget {
  const _ProfileData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(Preferences.email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(snapshot.hasData){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextForm(label: 'Nombre', value: snapshot.data!['name'], icon: Icons.person_outline),
                const SizedBox(height: 15),
                _TextForm(label: 'Apellidos', value: snapshot.data!['lastName'], icon: Icons.person_outline),
                const SizedBox(height: 15),
                _TextForm(label: 'Email', value: Preferences.email, icon: Icons.email_outlined),
                const SizedBox(height: 15),
                _TextForm(label: 'Departamento', value: snapshot.data!['role'], icon: Icons.work_outline),

                const SizedBox(height: 50),
                const _TextForm(label: 'Email de contacto', value: 'jose@gmail.com', icon: Icons.email_outlined),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator.adaptive(strokeWidth: 3, valueColor:AlwaysStoppedAnimation<Color>(Colors.white));
        }

      },
    );
  }
}

// Text design
class _TextForm extends StatelessWidget {

  final String label;
  final String value;
  final IconData icon;

  const _TextForm({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: value,
      decoration: _buildInputDecoration(context),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),

      prefixIcon: Icon(icon , color: Theme.of(context).primaryColor,),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: label,
    );
  }
}





