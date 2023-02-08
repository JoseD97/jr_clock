import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jr_clock/providers/providers.dart';
import 'package:jr_clock/services/services.dart';
import 'package:jr_clock/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  // TODO PERSONALIZAR EL DROPDOWNMENU
  // TODO PONER VALIDACIONES

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login card
                  CustomCard(
                    child: Column(
                      children: const [
                        // Title
                        Text('Registro', style: TextStyle(color: Colors.black87, fontSize: 34) ),
                        SizedBox(height: 30),

                        // Form
                        _RegisterForm(),
                      ],
                    ),
                  ),

                  // Forgotten password button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('login'),
                    style: ButtonStyle(shape:MaterialStateProperty.all(const StadiumBorder())),
                    child: Text('¿Ya tienes una cuenta?', style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),

                ]
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.black87,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.5]
        )
    );
  }
}

// Register form -> name, email and password
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Name
          const _TextFormName(label: 'Nombre'),

          // Last Name
          const SizedBox(height: 25,),
          const _TextFormName(label: 'Apellidos'),

          // Role
          const SizedBox(height: 25,),
          const _DropDownRole(),

          // Email
          const SizedBox(height: 25,),
          const _TextFormEmail(),

          // Password
          const SizedBox(height: 25,),
          const _TextFormPassword(),

          // Button
          const SizedBox(height: 25,),
          const _ElevatedButton(),

          // Terms and conditions
          const SizedBox(height: 25,),
          Text('Al resgistrarte, aceptas nuestros Términos y Condiciones.', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
        ],
      ),

    );
  }
}


// Name and last name
class _TextFormName extends StatelessWidget {

  final String label;

  const _TextFormName({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return TextFormField(
      autocorrect: false,
      decoration: _buildInputDecoration(context),
      keyboardType: TextInputType.name,
      onChanged: (value) => (label == 'Nombre') ? authProvider.name = value : authProvider.lastName = value,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1
          )
      ),

      prefixIcon: Icon(Icons.person_outline , color: Theme.of(context).primaryColor,),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: label,
      hintText: label,
    );
  }
}


// Role
class _DropDownRole extends StatelessWidget {
  const _DropDownRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)
        ),

        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1
            )
        ),

        prefixIcon: Icon(Icons.work_outline, color: Theme.of(context).primaryColor,),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelText: 'Rol',
        //hintText: 'Contraseña',
      ),
      items: const [
        DropdownMenuItem(value: 'Rol', child: Text('Rol')), //TODO BUSCAR LA FORMA DE PONER UN HINT
        DropdownMenuItem(value: 'JR Marketing', child: Text('JR Marketing')),
        DropdownMenuItem(value: 'JR Contabilidad', child: Text('JR Contabilidad')),
      ],
      value: authProvider.dropDownItem,
      onChanged: (value) => authProvider.dropDownItem = value!,
    );
  }
}


// Email
class _TextFormEmail extends StatelessWidget {
  const _TextFormEmail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return TextFormField(
      autocorrect: false,
      decoration: _buildInputDecoration(context),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => authProvider.email = value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp  = RegExp(pattern);
        return regExp.hasMatch(value ?? '')
            ? null
            : 'Introduce un correo válido';
      },

    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1
          )
      ),

      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Colors.red,
              width: 1
          )
      ),

      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Colors.red,
              width: 1
          )
      ),

      prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor,),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: 'Correo electrónico',
      hintText: 'Correo electrónico',
    );
  }
}


// Password
class _TextFormPassword extends StatelessWidget {
  const _TextFormPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return TextFormField(
      autocorrect: false,
      obscureText: authProvider.isObscured,
      onChanged: (value) => authProvider.password = value,
      decoration: _buildInputDecoration(context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return (value != null && value.length >= 6)
          ? null
          : 'Introduce una contraseña de al menos 6 caracteres';
      },
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1
          )
      ),

      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Colors.red,
              width: 1
          )
      ),

      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Colors.red,
              width: 1
          )
      ),

      prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor,),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: 'Contraseña',
      hintText: 'Contraseña',
      suffixIcon: IconButton(
        icon: Icon(authProvider.isObscured ? Icons.visibility : Icons.visibility_off, color: Colors.black87,),
        onPressed: () => authProvider.isObscured = !authProvider.isObscured,
      )
    );
  }
}


// Button
class _ElevatedButton extends StatelessWidget {
  const _ElevatedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        FocusScope.of(context).unfocus();
        final authService = Provider.of<AuthService>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final String? errorMessage = await authService.createUser(authProvider.email, authProvider.password);

        if(errorMessage == null){
          _createUserFB(email: authProvider.email, name: authProvider.name, lastName: authProvider.lastName, role: authProvider.dropDownItem); // Crea la coleccion en firebase
          Preferences.email = authProvider.email;
          ClockInFirestore.newUserDoc(context);
          Navigator.pushReplacementNamed(context, 'home'); //para no poder volver atras
        } else{
          NotificationsService.showSnackbar(errorMessage);
        }

      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
      ),
      child: const Text('Registrarse', style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }


  Future _createUserFB({
    required String email,
    required String name,
    required String lastName,
    required String role,
  }) async{
    // Create the new collection for the new user
    final newUser = FirebaseFirestore.instance.collection('users').doc(email);
    // Generate the json
    final json = <String, dynamic>{
      "name": name,
      "lastName": lastName,
      "role": role,
      "image": '-'
    };
    // Create document and write
    await newUser.set(json);
  }
}
