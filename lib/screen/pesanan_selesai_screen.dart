import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'detail_pesanan_screen.dart'; // Import the DetailPesananScreen

class CompletedOrdersPage extends StatelessWidget {
  const CompletedOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Selesai'),
        ),
        body: const Center(
          child: Text('Anda belum login'),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Pesanan Selesai',
              style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('pesanan_selesai')
            .orderBy('timestamp', descending: true) // Add ordering by timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Terjadi kesalahan saat mengambil data pesanan'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan selesai'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var orderData = doc.data() as Map<String, dynamic>;

              var name = orderData['name'] ?? '';
              var image = orderData['image'] ?? '';
              var price = orderData['price'] ?? 0;
              var quantity = orderData['quantity'] ?? 0;
              var timestamp = orderData['timestamp'] as Timestamp;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPesananScreen(orderData: orderData),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(image),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp $price',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 255, 46, 46)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: $quantity',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ordered at: ${timestamp.toDate()}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
