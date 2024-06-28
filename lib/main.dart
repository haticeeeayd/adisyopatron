import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'subeler.dart';


import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String username = 'Kullanıcı';
  String selectedDateRange = '';

  @override
  void initState() {
    super.initState();
    setSelectedDateRange();
  }
// Tarihi belirli bir formata dönüştürür
  void setSelectedDateRange() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    setState(() {
      // Seçili tarih aralığını günceller
      selectedDateRange = 'Bugün | $formattedDate';
    });
  }

  double calculatePercentChange(String today, String lastWeek) {
    double todayValue = extractNumericValue(today);
    double lastWeekValue = extractNumericValue(lastWeek);

    if (lastWeekValue == 0) {
      return 0.0;
    } else {
      // Değişim yüzdesini hesaplar
      return ((todayValue - lastWeekValue) / lastWeekValue) * 100;
    }
  }

  double extractNumericValue(String valueStr) {
    String numericStr = valueStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.parse(numericStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  selectedDateRange,
                  style: TextStyle(fontSize: 14),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Filtreleme işlemleri için dialog veya başka bir widget gösterilebilir
                  },
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'logout') {
                setState(() {
                  username = 'Kullanıcı';
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Çıkış Yap'),
              ),
            ],
            child: Row(
              children: [
                Text(username),
                Icon(Icons.account_circle),
              ],
            ),
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 16, 50, 85),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 50, 85),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/adisyoicon.png',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Adisyo Patron',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Ana Sayfa'),
                onTap: () {
                  Navigator.pop(context);// Menüyü kapatır ve ana sayfaya geri döner
                },
              ),
              ListTile(
                title: Text('Şubeler'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubelerSayfasi()),//şubeler sayfasına geçer
                  );
                },
              ),
              ListTile(
                title: Text('B2B'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Tanımlamalar'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Kullanıcılar'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Raporlar'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Ayarlar'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Entegrasyon İşlemleri'),
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //gösterge kartları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildDashboardItem('Aktif Şube Sayısı', 'Bugün: 10', 'Geçen Hafta Bugün: 15', ''),
                  buildDashboardItem('Toplam Satış Tutarı', 'Bugün: ₺0,00', 'Geçen Hafta Bugün: ₺0,00', ''),
                  buildDashboardItem('Toplam Sipariş Sayısı', 'Bugün: 0', 'Geçen Hafta Bugün: 0', ''),
                  buildDashboardItem('Ortalama Sipariş Tutarı', 'Bugün: ₺0,00', 'Geçen Hafta Bugün: ₺0,00', ''),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildLargeDashboardItem('Ana Ürün Satışları', 'Satış yapılmamış', '0 Adet', '0%'),
                  buildEmptyDashboardItem('Ödeme Tipine Göre Satışlar', 'Gösterilecek bilgi bulunamadı'),
                ],
              ),
              buildHourlySalesItem(),
              buildSubeBazliSatislarItem(),
              Row(
                children: [
                  Expanded(child: buildSalesStatusItem()),
                  Expanded(child: buildSalesByBranchItem()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboardItem(String title, String today, String lastWeek, String difference) {
    double percentChange = calculatePercentChange(today, lastWeek);//// Değişim yüzdesini hesaplar
    String formattedDifference = '${percentChange.toStringAsFixed(0)}%';

    return Expanded(
      child: Container(
        height: 150,
        margin: EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(today),
                Text(lastWeek),
                Text('Fark: $formattedDifference'),// Değişim yüzdesini gösterir
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLargeDashboardItem(String title, String detail1, String detail2, String detail3) {
    return Expanded(
      child: Container(
        height: 400,
        margin: EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  detail1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  detail2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  detail3,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Divider(color: Colors.red),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Gel-Al"),
                        SizedBox(height: 4),
                        Text("0 Adet"),
                      ],
                    ),
                    VerticalDivider(color: Colors.red),
                    Column(
                      children: [
                        Text("Paket"),
                        SizedBox(height: 4),
                        Text("0 Adet"),
                      ],
                    ),
                    VerticalDivider(color: Colors.red),
                    Column(
                      children: [
                        Text("Masa"),
                        SizedBox(height: 4),
                        Text("0 Adet"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyDashboardItem(String title, String message) {
    return Expanded(
      child: Container(
        height: 400,
        margin: EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubeBazliSatislarItem() {
    return Container(
      height: 400,
      margin: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Şubelere Göre Satışlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Şube 1'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Şube 2'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Şube 3'),
                      trailing: Text('₺0,00'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSalesStatusItem() {
    return Container(
      height: 300,
      margin: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Satış Durumu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Sipariş 1'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Sipariş 2'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Sipariş 3'),
                      trailing: Text('₺0,00'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSalesByBranchItem() {
    return Container(
      height: 300,
      margin: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Şubeye Göre Satışlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Şube 1'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Şube 2'),
                      trailing: Text('₺0,00'),
                    ),
                    ListTile(
                      title: Text('Şube 3'),
                      trailing: Text('₺0,00'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Saatlik satışları gösteren grafik oluşturur
  Widget buildHourlySalesItem() {
    return Container(
      height: 400,
      margin: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Saatlik Satışlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTextStyles: (value) => const TextStyle(
                          color: Color(0xff68737d),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return '00:00';
                            case 1:
                              return '02:00';
                            case 2:
                              return '04:00';
                            case 3:
                              return '06:00';
                            case 4:
                              return '08:00';
                            case 5:
                              return '10:00';
                            case 6:
                              return '12:00';
                            case 7:
                              return '14:00';
                            case 8:
                              return '16:00';
                            case 9:
                              return '18:00';
                            case 10:
                              return '20:00';
                            case 11:
                              return '22:00';
                          }
                          return '';
                        },
                        margin: 8,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                          color: Color(0xff67727d),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 1:
                              return '1k';
                            case 3:
                              return '3k';
                            case 5:
                              return '5k';
                          }
                          return '';
                        },
                        reservedSize: 32,
                        margin: 12,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Color(0xff37434d), width: 1),
                    ),
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 3.1),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: true,
                        colors: [
                          Color(0xff23b6e6),
                          Color(0xff02d39a),
                        ],
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          colors: [
                            Color(0xff23b6e6).withOpacity(0.3),
                            Color(0xff02d39a).withOpacity(0.3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
