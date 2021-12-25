import 'package:flutter/material.dart';
import 'package:tk2_pbp/screens/form_donor.dart';
import 'package:tk2_pbp/helpers/authenticated_request.dart';
import 'package:provider/provider.dart';

class FormDonorScreen extends StatefulWidget {
  static const routeName = '/form_donor';
	
  const FormDonorScreen({Key? key}) : super(key: key);
	
  @override
  _FormDonorScreenState createState() => _FormDonorScreenState();
}

class _FormDonorScreenState extends State<FormDonorScreen> {
	@override
	Widget build(BuildContext context) {
	final request = context.watch<CookieRequest>();
    return Scaffold(
		appBar: AppBar(
			title: Text("Form Donor"),
			leading: IconButton(
				icon: Icon(Icons.arrow_back,
					color: Colors.white),
				onPressed: (){Navigator.of(context).pop(true);}
			),
			actions: [
				Padding(
					padding: EdgeInsets.only(right: 5),
					child: IconButton(
					icon: Icon(
						Icons.info_outline,
						color: Colors.white),
					onPressed: (){
						AlertDialog alert = AlertDialog(
							title: Text("Syarat Pendonor Plasma Konvalesen"),
							content: Text('''1. Telah sembuh dari COVID-19.
2. Tidak memiliki gejala COVID-19 minimal selama 14 hari sebelum donor.
3. Berusia 18-60 tahun dengan berat badan minimal 55 kg.
4. Diutamakan laki-laki, jika perempuan maka disyaratkan belum pernah hamil.
5. Tidak memiliki riwayat transfusi darah selama minimal 6 bulan terakhir.
6. Tidak memiliki komorbid (penyakit penyerta).'''),
							actions: <Widget>[
								TextButton(
									onPressed: () => Navigator.pop(context, 'OK'),
									child: Text('OK'),
								),
							],
						);
						showDialog(
							context: context,
							builder: (BuildContext context) {return alert;},
						);
					}
				)),
			],
			backgroundColor: const Color.fromRGBO(0, 41, 84, 1),
		  ),
		backgroundColor: Color(0xffdceaf9),
		body: SingleChildScrollView(child:Stack(
			children: <Widget>[
				Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Container(
							color: Colors.white,
							child: FormDonor(),
						),
				    ],
				),
			],
		),),
	);
	}
}