import 'package:flutter/material.dart';
import 'package:adisyo_patron/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adisyo Patron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SubelerSayfasi(),
    );
  }
}

class SubelerSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şubeler'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Şubeler',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Şube Limitleri'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Şube Ayarları'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Şube Ekle'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Şube sayısı: 1'),
            SizedBox(height: 16),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Şube')),
                DataColumn(label: Text('Yetkili Kişi')),
                DataColumn(label: Text('Telefon')),
                DataColumn(label: Text('Mail')),
                DataColumn(label: Text('Etiketler')),
                DataColumn(label: Text('İşlemler')),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('40567')),
                    DataCell(Text('azad')),
                    DataCell(Text('Yetkili Yok')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('Tanımlı etiket bulunamadı.')),
                    DataCell(Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: null,
                          child: Text('Şube Etiketle'),
                        ),
                        TextButton(
                          onPressed: null,
                          child: Text('Şube Ödemeleri'),
                        ),
                        TextButton(
                          onPressed: null,
                          child: Text('Düzenle'),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: 10,
                  items: <int>[10, 20, 30, 40].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {

                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.first_page),
                      onPressed: () {

                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {

                      },
                    ),
                    Text('1'),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {

                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.last_page),
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
