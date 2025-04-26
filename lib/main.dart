// Bu ödev, Dart diliyle asenkron programlama kullanılarak
// RandomUser API’den veri çekilmesi ve verilerin bir profil kartı üzerinde gösterilmesi amacıyla hazırlanmış olup,
// Erciyes Üniversitesi Bilgisayar Mühendisliği Bölümü öğrencisi
// 1030510576 numaralı Şeyma Gizem Sivri tarafından,
// BS 438 Mobile Application Development dersi kapsamında,
// Öğr. Gör. Dr. Fehim Köylü danışmanlığında gerçekleştirilmiştir.


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User Profile',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF9370DB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
        ),
        useMaterial3: true,
      ),
      home: const RandomUserPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RandomUserPage extends StatefulWidget {
  const RandomUserPage({super.key});

  @override
  State<RandomUserPage> createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  Map<String, dynamic>? userData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRandomUser();
  }

  Future<void> fetchRandomUser() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://randomuser.me/api/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userData = data['results'][0];
        isLoading = false;
      });
    } else {
      throw Exception('Kullanıcı verisi alınamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFFFFFFFF);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: AppBar(
            title: const Text(
              "Random Kullanıcı Profili",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            if (userData != null)
              Center(
                child: SizedBox(
                  width: 335,
                  height: 480,
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                userData!['picture']['large'],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${userData!['name']['first']} ${userData!['name']['last']}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Country: ${userData!['location']['country']}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            "Age: ${userData!['dob']['age']}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            "Email: ${userData!['email']}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                foregroundColor: Colors.black,
              ),
              onPressed: fetchRandomUser,
              icon: const Icon(Icons.refresh),
              label: const Text("Yeni Kullanıcı Getir"),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Yükleniyor, lütfen bekleyiniz..."),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
