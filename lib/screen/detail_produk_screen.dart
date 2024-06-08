import 'package:flutter/material.dart';

class DetailProdukScreen extends StatelessWidget {
  const DetailProdukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product',
            style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/product/nike1.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Rp. 1.250.000',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Sepatu Nike Air Jordan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const Divider(color: Colors.grey, height: 20.0),
            const Text(
              'Tentang Produk',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Nike Air Jordan adalah salah satu lini sepatu paling ikonik dalam dunia olahraga dan mode. Pertama kali diperkenalkan pada tahun 1984, sepatu ini dirancang khusus untuk bintang basket legendaris Michael Jordan. Dengan desain yang inovatif dan teknologi canggih, Air Jordan menjadi simbol performa tinggi dan gaya yang tak tertandingi.',
              style: TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Produk Ditambahkan ke Keranjang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const Text(
                              'Nike Air Jordan telah berhasil ditambahkan ke keranjang belanja Anda.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 90, vertical: 15),
                                ),
                                child: const Text('Tutup'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                ),
                child: const Text("Tambahkan Keranjang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DetailProdukScreen(),
  ));
}
