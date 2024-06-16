import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detail_produk_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.teal,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            // BACKGROUND HEADER
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // TITLE/HEADER
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best Product',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Selamat berbelanja!',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),

                  // SEARCH BOX
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 1.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cari Sepatu Yang Anda Inginkan!',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                ],
              ),
            ),

            // BUTTON CATEGORY
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _filterByCategory('All'),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedCategory == 'All'
                            ? Colors.teal
                            : Color.fromARGB(255, 211, 211, 211),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: _selectedCategory == 'All' ? 3 : 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(
                          color: _selectedCategory == 'All'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _filterByCategory('Men'),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedCategory == 'Men'
                            ? Colors.teal
                            : Color.fromARGB(255, 211, 211, 211),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: _selectedCategory == 'Men' ? 3 : 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text(
                        'Men',
                        style: TextStyle(
                          color: _selectedCategory == 'Men'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _filterByCategory('Women'),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedCategory == 'Women'
                            ? Colors.teal
                            : Color.fromARGB(255, 211, 211, 211),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: _selectedCategory == 'Women' ? 3 : 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text(
                        'Women',
                        style: TextStyle(
                          color: _selectedCategory == 'Women'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _filterByCategory('Kids'),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedCategory == 'Kids'
                            ? Colors.teal
                            : Color.fromARGB(255, 211, 211, 211),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: _selectedCategory == 'Kids' ? 3 : 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text(
                        'Kids',
                        style: TextStyle(
                          color: _selectedCategory == 'Kids'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            // LIST PRODUCT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('shoes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  final data = snapshot.requireData;
                  final filteredData = data.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final category = doc['category'].toString().toLowerCase();
                    final query = _searchQuery.toLowerCase();
                    return name.contains(query) &&
                        (_selectedCategory == 'All' ||
                            category == _selectedCategory.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final shoe = filteredData[index];
                      return ProductCard(
                        productId: shoe.id,
                        name: shoe['name'],
                        material: shoe['material'],
                        price: shoe['price'],
                        imageUrl: shoe['image'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String material;
  final int price;
  final String imageUrl;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.name,
    required this.material,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 5,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProdukScreen(productId: productId),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 130,
              height: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 110,
                      width: double.infinity,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'New',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Bahan : $material',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Rp. $price',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: ' / pcs',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
