
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:jr_clock/services/services.dart';
import 'package:jr_clock/widgets/profile_image.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import 'package:intl/date_symbol_data_local.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('email2 ' + Preferences.email);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: _boxDecorationScaffold(),

        child: Column(
          children: const [
            _TopBlackBox(),

            _HomeBody(),

          ],
        ),

      ),
    );
  }



  BoxDecoration _boxDecorationScaffold() {
    return const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.black87,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.3]
        )
    );
  }

}


// User information
class _TopBlackBox extends StatelessWidget {
  const _TopBlackBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(20),

        child: Row(
          children: [
            // Profile Image
            ProfileImage(height: 100, width: 100,),

            // Name and role from Firebase
            const SizedBox(width: 20,),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(Preferences.email).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white)),
                        const SizedBox(height: 5,),
                        Text(snapshot.data!['role'], style: const TextStyle(fontSize: 18, color: Colors.white)),
                      ],
                    );

                  } else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }

              ),
            ),

            // Logout Button
            const SizedBox(width: 20,),
            IconButton(
                onPressed: () {
                  authService.logOut();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white,)
            ),

          ],
        ),
      ),
    );
  }
}


class _HomeBody extends StatelessWidget {
  const _HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: _buildBoxDecorationBody(),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const _ClockInSection(),

              const SizedBox(height: 30,),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Card(
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(context, 'historic'),
                        title: const Text('Historial de fichajes'),
                        leading: const Icon(Icons.history),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(context, 'profile'),
                        title: const Text('Perfil'),
                        leading: const Icon(Icons.person_rounded),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  BoxDecoration _buildBoxDecorationBody() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),

    );
  }

}


class _ClockInSection extends StatelessWidget {
  const _ClockInSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authClockIn = Provider.of<AuthClockIn>(context);

    return Column(
      children: [ //TODO MAPA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _DayClockIn(),

            _TimeClockIn(),
          ],
        ),

        const SizedBox(height: 20),

        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 200,
            width: 350,
            // color: Colors.red,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(authProvider.loginLat, authProvider.loginLong),
                zoom: 18,
                interactiveFlags: InteractiveFlag.none,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: null,
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                      showHeadingSector: false
                  ),
                ), // quitar la sombra de para donde esta mirando
              ],
            ),
          ),
        ),


        const SizedBox(height: 20),

        SizedBox(
          height: 45,
          width: 250,
          child: ElevatedButton(
            onPressed: authClockIn.isLoading
                ? null
                : () async {
              authClockIn.isLoading = true;
              final now = DateTime.now();
              var data = await ClockInFirestore.getDataLastDocument();
              print('tras pulsar el boton');
              print('countttttttttt ' + data['countPerDay'].toString());
              print('iswoerking ' + data['isWorking'].toString());
              print('/tras pulsar el boton');

              if (data['day'] != now.day){ // Comprobacion por si el ultimo dia se le olvido fichar la salida
                ClockInFirestore.enterWork(context);
                NotificationsService.showSnackbar('Entrada fichada');
                authClockIn.isLoading = false;
              }
              else{
                if(data['isWorking']) {
                  await ClockInFirestore.leaveWork(context);
                  NotificationsService.showSnackbar('Salida fichada');
                  authClockIn.reloadStreamBuilder = false;
                } else {
                  await ClockInFirestore.enterWork(context);
                  NotificationsService.showSnackbar('Entrada fichada'); // todo si no hay error
                  authClockIn.reloadStreamBuilder = true;
                }  // TODO poner que se esperar a confirmar la grabacion

                authClockIn.isLoading = false;
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: authClockIn.isLoading
                ? const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 3, valueColor:AlwaysStoppedAnimation<Color>(Colors.white)),
                )
                : const Text('Fichar', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],

    );
  }


}



class _DayClockIn extends StatelessWidget {
  const _DayClockIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    initializeDateFormatting(); // Para poder poner la fecha en español

    final now = DateTime.now();
    return Row(
      children: [
        Text(now.day.toString(), style: const TextStyle(fontSize: 35),),
        const SizedBox(width: 10,),
        Text(DateFormat('MMMM','es').format(now).toString()),
      ],
    );
  }
}


class _TimeClockIn extends StatelessWidget {
  const _TimeClockIn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final authClockIn = Provider.of<AuthClockIn>(context);
    Stream myStream = currentSigningStream();
    if(authClockIn.reloadStreamBuilder) myStream = currentSigningStream();

    final now = DateTime.now();
    var count = ClockInFirestore.count;
    print('cont'+ count.toString());
    if(count > 1) count--; // para que seleccione el documento anterior
    final doc = '${now.year}-${now.month}-${now.day}-${count.toString()}';
    print('doc $doc');

    return Row(
        children: [
          Column(
            children: const [
              Icon(Icons.arrow_forward_outlined, color: Colors.green,),
              Icon(Icons.arrow_back_outlined, color: Colors.redAccent,),
            ],
          ),

          const SizedBox(width: 10),

          StreamBuilder(
              //initialData: await ClockInFirestore.getIDLastDocument();,
              stream: myStream,
              builder: (context, snapshot) {
                if (snapshot.hasData ) {  // si el documento tiene datos
                  if(snapshot.data!.exists){  // si el documento existe
                    return Column(
                      children: [
                        Text(snapshot.data!["hourIn"].toString()),
                        const SizedBox(height: 6),
                        Text(snapshot.data!["hourOut"].toString()),
                      ],
                    );
                  } else{
                    //ClockInFirestore.createDocument();
                    return Column(
                      children: const [
                        Text('  -  '),
                        SizedBox(height: 6),
                        Text('  -  '),
                      ],
                    );
                  }
                } else{
                  return const Center(child: CircularProgressIndicator.adaptive(valueColor:AlwaysStoppedAnimation<Color>(Colors.black87)));
                }
              }

          ),
        ]
    );
  }


  Stream currentSigningStream() async* {

    final lastId = await ClockInFirestore.getIDLastDocument();
    print('lastid>>>>>>>' + lastId);
    yield* FirebaseFirestore.instance.collection(Preferences.email).doc(lastId).snapshots();
  }
}

