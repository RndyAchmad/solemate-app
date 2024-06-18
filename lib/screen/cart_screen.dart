import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
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
                                        Text(
                                          'Rp $price',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 255, 46, 46)),
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
                                          if (quantity == 1) {
                                            _showDeleteConfirmationDialog(
                                                context, doc.id);
                                          } else {
                                            _kurangiJumlahProduk(
                                                doc.id, quantity);
                                          }
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
              ElevatedButton(
                onPressed: () {
                  _showCheckoutConfirmationDialog(context, snapshot.data!.docs);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - (2 * 24),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Center(
                    child: Text(
                      'Check Out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
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

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus produk ini dari keranjang?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                _kurangiJumlahProduk(docId, 1);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutConfirmationDialog(
      BuildContext context, List<DocumentSnapshot> cartProducts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Checkout'),
          content: const Text(
              'Apakah Anda yakin ingin melanjutkan ke proses checkout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lanjutkan'),
              onPressed: () {
                Navigator.of(context).pop();
                _checkOut(cartProducts);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkOut(List<DocumentSnapshot> cartProducts) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Iterate over each product in cart and move to 'pesanan_selesai'
    for (DocumentSnapshot cartProduct in cartProducts) {
      var cartData = cartProduct.data() as Map<String, dynamic>;
      var productId = cartData['productId'];
      var quantity = cartData['quantity'];

      // Reference to the document in 'keranjang'
      DocumentReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('keranjang')
          .doc(cartProduct.id);

      // Reference to the document to be added in 'pesanan_selesai'
      DocumentReference orderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('pesanan_selesai')
          .doc();

      // Get product details from 'shoes' collection
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        var productData = productSnapshot.data() as Map<String, dynamic>;

        // Build the data to be moved to 'pesanan_selesai'
        var orderData = {
          'productId': productId,
          'name': productData['name'],
          'image': productData['image'],
          'price': productData['price'],
          'quantity': quantity,
          'timestamp': Timestamp.now(),
        };

        // Add to batch
        batch.set(orderRef, orderData);
        batch.delete(cartRef);
      }
    }

    try {
      // Commit the batch
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan berhasil dibuat'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat proses check out'),
        ),
      );
    }
  }
}
