import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan UID pengguna saat ini
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang'),
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
              'Keranjang',
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
            .collection('keranjang')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Terjadi kesalahan saat mengambil data keranjang'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Keranjang kosong'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var cartData = doc.data() as Map<String, dynamic>;
                    var productId = cartData['productId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('shoes')
                          .doc(productId)
                          .get(),
                      builder: (context, productSnapshot) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (productSnapshot.hasError ||
                            !productSnapshot.hasData ||
                            !productSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('Produk tidak ditemukan'),
                          );
                        }

                        var productData = productSnapshot.data!.data()
                            as Map<String, dynamic>;

                        // Memastikan 'name', 'image', 'quantity', dan 'price' tidak null
                        var name = productData['name'] ?? '';
                        var image = productData['image'] ?? '';
                        var price = productData['price'] ?? 0;
                        var quantity = cartData['quantity'] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Divider(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Harga dan jumlah
                                        Text(
                                          'Rp $price',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Quantity: $quantity',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Tombol untuk menambah atau mengurangi jumlah
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _tambahJumlahProduk(doc.id);
                                        },
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          _kurangiJumlahProduk(
                                              doc.id, quantity);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  void _kurangiJumlahProduk(String docId, int currentQuantity) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('keranjang')
        .doc(docId);

    if (currentQuantity > 1) {
      cartRef.update({
        'quantity': FieldValue.increment(-1),
      });
    } else {
      cartRef.delete();
    }
  }

  void _tambahJumlahProduk(String docId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('keranjang')
        .doc(docId)
        .update({
      'quantity': FieldValue.increment(1),
    });
  }
}
