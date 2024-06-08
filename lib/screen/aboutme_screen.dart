import 'package:flutter/material.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'Solemate APPS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  Image.asset('assets/image/logo.png', height: 111),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 250,
                    child: Text(
                      'Solemate Apps adalah platform digital yang dirancang untuk membantu pengguna dalam memilih dan membeli sepatu yang paling sesuai dengan kebutuhan dan preferensi mereka. Solemate menawarkan pengalaman belanja sepatu yang dipersonalisasi, interaktif, dan inovatif.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const ProfileCard(
              name: 'Rendy Achmadiansyah Mukti',
              id: '22082010028',
              program: 'Sistem Informasi 2022',
              location: 'Surabaya, Indonesia',
              imagePath: 'assets/image/rendy.jpg',
            ),
            const SizedBox(height: 24),
            const ProfileCard(
              name: 'Paloma Ransi',
              id: '22082010024',
              program: 'Sistem Informasi 2022',
              location: 'Surabaya, Indonesia',
              imagePath: 'assets/image/ransi.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String id;
  final String program;
  final String location;
  final String imagePath;

  const ProfileCard({
    super.key,
    required this.name,
    required this.id,
    required this.program,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imagePath),
                  )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(program),
                  Text(location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
