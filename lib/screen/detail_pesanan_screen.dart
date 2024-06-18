import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPesananScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const DetailPesananScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  _DetailPesananScreenState createState() => _DetailPesananScreenState();
}

class _DetailPesananScreenState extends State<DetailPesananScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> kirimUlasan(String ulasan) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user document to get full_name
        DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
        String displayName = userDoc['full_name'] ?? 'Anonymous';

        // Send review
        await _db.collection('ulasan').add({
          'uid': uid,
          'productId': widget.orderData['productId'],
          'displayName': displayName,
          'ulasan': ulasan,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ulasan berhasil dikirim')),
        );

        // Clear the comment field after submitting
        _commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap login terlebih dahulu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim ulasan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = widget.orderData['name'] ?? '';
    var image = widget.orderData['image'] ?? '';
    var price = widget.orderData['price'] ?? 0;
    var quantity = widget.orderData['quantity'] ?? 0;
    var timestamp = widget.orderData['timestamp']?.toDate() ?? DateTime.now();

    // Calculate total price
    var totalPrice = price * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.network(
            image,
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
                                name,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text.rich(
                                TextSpan(
                                  text: 'Rp. $price',
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
                        'Quantity: $quantity',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total Harga: Rp. $totalPrice',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: $timestamp',
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
                        'Kirim Ulasan Anda',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Masukkan ulasan Anda...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            String ulasan = _commentController.text.trim();
                            if (ulasan.isNotEmpty) {
                              kirimUlasan(ulasan);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ulasan tidak boleh kosong'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'Kirim Ulasan',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
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
      ),
    );
  }
}
