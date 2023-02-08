
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jr_clock/providers/providers.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class HistoricScreen extends StatelessWidget {
  const HistoricScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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


// Title
class _TopBlackBox extends StatelessWidget {
  const _TopBlackBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: false,
      child: Container(
        width: size.width,
        height: 150,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text('Historial de fichajes', style: TextStyle(color: Colors.white, fontSize: 25),),
        ),
      ),
    );
  }
}


// Body
class _HomeBody extends StatelessWidget {
  const _HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final historicProvider = Provider.of<HistoricProvider>(context);
    final size = MediaQuery.of(context).size;
    final month = historicProvider.month;
    final year = historicProvider.year;

    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(5),
          width: size.width,
          decoration: _buildBoxDecorationBody(),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const _Filter(),

              const SizedBox(height: 15,),
              const Divider(),

              historicProvider.showData   // Muestra el historial tras pulsar el boton
                  ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Preferences.email)
                      .where('year', isEqualTo: year)
                      .where('month', isEqualTo: month)
                      .orderBy(descending: true, 'day')
                      .limit(70)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData ) {  // TODO PONER MENSAJE SI NO SE RECIBE NINGUN DATO y el HAS.ERROR por errores de conexion
                      return Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder:(context, index){
                              return CustomCardHistoric(
                                day: snapshot.data!.docs[index]['day'].toString(),
                                month: snapshot.data!.docs[index]['month'].toString(),
                                year: snapshot.data!.docs[index]['year'].toString(),
                                hourIn: snapshot.data!.docs[index]['hourIn'].toString(),
                                hourOut: snapshot.data!.docs[index]['hourOut'].toString(),
                                locationIn: snapshot.data!.docs[index]['locationIn'].toString(),
                                locationOut: snapshot.data!.docs[index]['locationOut'].toString(),
                              );
                            }
                        ),
                      );
                    } else return const CircularProgressIndicator.adaptive(strokeWidth: 3, valueColor:AlwaysStoppedAnimation<Color>(Colors.white));

                  })
                  : const Text('Pulse el botón de buscar para ver resultados', style: TextStyle(color: Colors.grey)),


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

class _Filter extends StatelessWidget {
  const _Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historicProvider = Provider.of<HistoricProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            // Month
            SizedBox(
              height: 45,
              width: 100,
              child: TextFormField(
                initialValue: historicProvider.month.toString(),
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(context, 'Mes'),
                onChanged: (value) => historicProvider.month = int.parse(value),
              ),
            ),

            const SizedBox(height: 10,),

            // Year
            SizedBox(
              height: 45,
              width: 100,
              child: TextFormField(
                initialValue: historicProvider.year.toString(),
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(context, 'Año'),
                onChanged: (value) => historicProvider.year = int.parse(value),
              ),
            )
          ],
        ),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            onPressed:
            historicProvider.isSearching
                ? null
                : () {
              // if(historicProvider.month == '' && historicProvider.year == '') null; // bloquea boton si no se han introducido filtros
              // else{
              FocusScope.of(context).unfocus();
              historicProvider.showData = true;
              historicProvider.isSearching = true;
              //TODO poner logica -> activar el stream builder
              historicProvider.isSearching = false;
              // }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))
            ),
            child: historicProvider.isSearching
                ? const SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator.adaptive(strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            )
                : const Text('Buscar', style: TextStyle(fontSize: 20)),
          ),
        )
      ],
    );
  }


  InputDecoration _buildInputDecoration(BuildContext context, String labelText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Theme
              .of(context)
              .primaryColor)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Theme
                  .of(context)
                  .primaryColor,
              width: 1
          )
      ),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: labelText,
    );
  }
}


