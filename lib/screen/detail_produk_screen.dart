import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailProdukScreen extends StatefulWidget {
  final String productId;

  const DetailProdukScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _DetailProdukScreenState createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> showConfirmation() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah kamu ingin menambahkan produk ke keranjang?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tambahkan'),
              onPressed: () async {
                Navigator.of(context).pop();
                await tambahkanProdukKeKeranjang(widget.productId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Produk ditambahkan ke keranjang')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> tambahkanProdukKeKeranjang(String productId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Check if the product is already in the cart
        DocumentSnapshot doc = await _db
            .collection('users')
            .doc(uid)
            .collection('keranjang')
            .doc(productId)
            .get();

        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          // If the product is already in the cart, increase the quantity
          int jumlah = (data['quantity'] ?? 0) + 1;
          await _db
              .collection('users')
              .doc(uid)
              .collection('keranjang')
              .doc(productId)
              .update({'quantity': jumlah});
        } else {
          // If the product is not in the cart, add it as a new product
          await _db
              .collection('users')
              .doc(uid)
              .collection('keranjang')
              .doc(productId)
              .set({
            'productId': productId,
            'quantity': 1,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap login terlebih dahulu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('shoes')
            .doc(widget.productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching product details'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Product not found'));
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            children: [
              Image.network(
                productData['image'],
                width: MediaQuery.of(context).size.width,
                height: 500,
                fit: BoxFit.cover,
              ),
              ListView(
                padding: EdgeInsets.only(top: 328),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['name'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Rp. ${productData['price']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' / pcs',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Text(
                            'Tentang Produk',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            productData['description'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Text(
                            'Bahan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            productData['material'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Text(
                            'Ulasan Pengguna',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('ulasan')
                                .where('productId', isEqualTo: widget.productId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text(
                                  '-- Produk ini belum ada ulasan --',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.justify,
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: snapshot.data!.docs.map((document) {
                                  var reviewData =
                                      document.data() as Map<String, dynamic>;

                                  // Check if displayName is not null or empty
                                  String displayName =
                                      reviewData['displayName'];
                                  // ignore: unnecessary_null_comparison
                                  if (displayName == null ||
                                      displayName.isEmpty) {
                                    displayName = 'Anonymous';
                                  }

                                  // Use full_name if available
                                  if (reviewData.containsKey('full_name')) {
                                    displayName = reviewData['full_name'];
                                  }

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '$displayName',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' memberikan ulasan :',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            reviewData['ulasan'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showConfirmation();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - (2 * 24),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Center(
                          child: Text(
                            'Tambahkan ke Keranjang',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 45, left: 14, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/image/back.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
