import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tk2_pbp/helpers/authenticated_request.dart';
import 'package:provider/provider.dart';

class FormDonor extends StatefulWidget {
  const FormDonor({Key? key}) : super(key: key);

  @override
  FormDonorState createState() {
    return FormDonorState();
  }
}

class FormDonorState extends State<FormDonor> {
    final _formKey = GlobalKey<FormState>();
    TextEditingController dateController = TextEditingController();
    String? jenis_kelamin = "Laki-Laki";
    String? golongan_darah = "A";
    String? rhesus = "+";
    String? nama;
    String? nomor_induk;
    String? nomor_hp;
    String? tempat_lahir;
    String? tinggi_badan;
    String? berat_badan;
    String? alamat;
    bool noKomorbid = false;
    DateTime tanggal_lahir = DateTime.now();
    
    Future selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1337),
          lastDate: DateTime.now());
      if (picked != null)
        setState(() {
            tanggal_lahir = picked;
            var date = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
            dateController.text = date;
        });
    }
    
    @override
    Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Form(key: _formKey,
        child:Container(
        padding:EdgeInsets.only(top:35, left:20,right:20, bottom:20),
        child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,  
                children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                nama = value;
                            },
                            decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            
                            validator: (value) {
                                if (value!.isEmpty)
                                    return "Wajib diisi";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                nomor_induk = value;
                            },
                            decoration: InputDecoration(
                                labelText: "NIK",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value){
                                if(value!.isEmpty || value.length!=16 || !RegExp(r'^[0-9]+$').hasMatch(value)) 
                                    return "NIK harus terdiri dari 16 angka";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                nomor_hp = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Nomor HP",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value){
                                if(value!.isEmpty) 
                                    return "Wajib diisi";
                                if(!RegExp(r'^[0-9]+$').hasMatch(value))
                                    return "Mohon masukkan angka";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:DropdownButtonFormField(
                            value: jenis_kelamin,
                            items: ["Laki-Laki", "Perempuan"]
                                .map<DropdownMenuItem<String>>((String value){
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                }).toList(),
                            onChanged: (String? value){
                                setState((){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    jenis_kelamin = value;
                                });
                            },
                            decoration: InputDecoration(
                                labelText: "Jenis Kelamin",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                tempat_lahir = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Tempat Lahir",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value) {
                                if (value!.isEmpty)
                                    return "Wajib diisi";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onTap: () => selectDate(context),
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                                labelText: "Tanggal Lahir",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value) {
                                if (value!.isEmpty)
                                    return "Wajib diisi";
                                if(DateTime.now().year - tanggal_lahir.year < 18 || DateTime.now().year - tanggal_lahir.year > 60)
                                    return "Pendonor harus berusia 18-60 tahun.";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                alamat = value;
                            },
                            maxLines: 2,
                            decoration: InputDecoration(
                                labelText: "Alamat",
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value) {
                                if (value!.isEmpty)
                                    return "Wajib diisi";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child: Row(
                        children: <Widget>[
                        Flexible(
                            child:DropdownButtonFormField(
                                value: golongan_darah,
                                items: ["A", "B", "O", "AB"]
                                    .map<DropdownMenuItem<String>>((String value){
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                        );
                                    }).toList(),
                                onChanged: (String? value){
                                    setState((){
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        golongan_darah = value;
                                    });
                                },
                                decoration: InputDecoration(
                                    labelText: "Golongan Darah",
                                    contentPadding: EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(1.0)),
                                ),
                            ),
                        ),
                        Flexible(
                            child:DropdownButtonFormField(
                                value: rhesus,
                                items: ["+", "-"]
                                    .map<DropdownMenuItem<String>>((String value){
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                        );
                                    }).toList(),
                                onChanged: (String? value){
                                    setState((){
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        rhesus = value;
                                    });
                                },
                                decoration: InputDecoration(
                                    labelText: "Rhesus",
                                    contentPadding: EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(1.0)),
                                ),
                            ),
                        ),
                    ]),
                    ),
                    
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                berat_badan = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Berat Badan",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value){
                                if(value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value) || int.parse(value)<55) 
                                    return "Berat badan minimal pendonor adalah 55 kg.";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:TextFormField(
                            onSaved: (String? value){
                                tinggi_badan = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Tinggi Badan",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            ),
                            validator: (value){
                                if(value!.isEmpty) 
                                    return "Wajib diisi";
                                if(!RegExp(r'^[0-9]+$').hasMatch(value))
                                    return "Mohon masukkan angka";
                                return null;
                            },
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child:CheckboxListTile(
                            title: Text("Tidak memiliki penyakit penyerta/komorbid.", style: TextStyle(fontWeight: FontWeight.bold)),
                            value: noKomorbid,
                            onChanged: (bool? value) {
                                setState(() {
                                    noKomorbid = value!;
                                });
                            },
                            subtitle: !noKomorbid
                              ? Text("Pendonor disyaratkan tidak memiliki penyakit penyerta bersifat kronis maupun penyakit yang dapat menular melalui darah.", style: TextStyle(color: Colors.red),): null,
                        ),
                    ),
                    Container(
                        width: double.infinity,
                        child:RaisedButton(
                            color: Color.fromRGBO(0, 41, 84, 1), 
                            onPressed: () async{
                                if(_formKey.currentState!.validate() && noKomorbid){
                                    _formKey.currentState!.save();
                                    final response = await request.post(
                                        "http://192.168.100.114:8000/form-donor/mobile",
                                        jsonEncode(<String, String>{
                                            "nama": nama!,
                                            "nomor_induk": nomor_induk!,
                                            "nomor_hp": nomor_hp!,
                                            "jenis_kelamin": jenis_kelamin!,
                                            "tempat_lahir": tempat_lahir!,
                                            "tanggal_lahir": tanggal_lahir.toString(),
                                            "alamat": alamat!,
                                            "golongan_darah": golongan_darah!,
                                            "rhesus": rhesus!,
                                            "berat_badan": berat_badan!,
                                            "tinggi_badan": tinggi_badan!,
                                            "komorbid": "Tidak"
                                        })
                                    );
                                    if(response["status"] == "ok"){
                                        AlertDialog alert = AlertDialog(
                                          title: Text('Sukses'),
                                          content: Text('Request Anda telah berhasil dikirim.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.popAndPushNamed(context, "/"),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }
                                    else{
                                        AlertDialog alert = AlertDialog(
                                          title: Text('Gagal'),
                                          content: Text(response["msg"]),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }
                                }
                                else{
                                    AlertDialog alert = AlertDialog(
                                          title: Text('Gagal'),
                                          content: Text('Periksa kembali formulir Anda.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                }
                            },
                            child: Text("Submit"),
                            textColor: Colors.white,
                        ),
                    ),
                ],
            ),
        ),
    );
    }
}