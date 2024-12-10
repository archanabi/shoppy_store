import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class passdata extends StatefulWidget {
  const passdata({super.key});
  @override
  State<passdata> createState() => _passdataState();
}
class _passdataState extends State<passdata> {
  List products = [];
  List<Map> cart = []; 
  List<Map> wishlist = []; 
   @override
  void initState() {
    super.initState();
    fetchJewellery();
  }
 Future<void> fetchJewellery() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=50'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        throw Exception('Unable to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
void addToCart(Map product) {
    setState(() {
      cart.add(product);
    });
  }void addToWishlist(Map product) {

    setState(() {
      wishlist.add(product);
    });
  }
 void removeFromCart(Map product) {
    setState(() {
      cart.remove(product);
    });
  }
void removeFromWishlist(Map product) {
    setState(() {
      wishlist.remove(product);
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 235, 245),
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              Text(
                'SHOPPY STORE',
                style: TextStyle(
                  color: const Color.fromARGB(235, 44, 128, 138),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: const Color.fromARGB(235, 44, 128, 138),),
                onPressed: () {
                  // Navigate to Cart screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: cart,
                        removeFromCart: removeFromCart,
                      ),
                    ),
                  );
                },
              ),
              Text('${cart.length}'), // Show the number of items in the cart
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.favorite, color: const Color.fromARGB(235, 44, 128, 138),),
                onPressed: () {
                  // Navigate to Wishlist screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishlistScreen(
                        wishlist: wishlist,
                        removeFromWishlist: removeFromWishlist,
                      ),
                    ),
                  );
                },
              ),
              Text('${wishlist.length}'), 
            ],
          ),
        ),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          product: product,
                          addToCart: addToCart,
                          addToWishlist: addToWishlist,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            product['image'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(235, 44, 128, 138),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text('\$${product['price']}'),
                                SizedBox(height: 5),
                                Text(product['category']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
class ProductDetails extends StatelessWidget {
  final Map product;
  final Function addToCart;
  final Function addToWishlist;

  const ProductDetails({
    required this.product,
    required this.addToCart,
    required this.addToWishlist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 235, 245),
      appBar: AppBar(
        title: Text(product['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['image'],
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              product['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$ ${product['price']}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              product['category'],
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    addToWishlist(product);
                    Navigator.pop(context); 
                  },
                  child: Text(
                    "Add to Wishlist",
                    style: TextStyle(
                      color: const Color.fromARGB(235, 44, 128, 138),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    addToCart(product); 
                    Navigator.pop(context); 
                  },
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: const Color.fromARGB(235, 44, 128, 138),
                    ),
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
class CartScreen extends StatelessWidget {
  final List<Map> cart;
  final Function removeFromCart;

  CartScreen({required this.cart, required this.removeFromCart});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final product = cart[index];
                return ListTile(
                  leading: Image.network(product['image']),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeFromCart(product); 
                      Navigator.pop(context); 
                    },
                  ),
                );
              },
            ),
    );
  }
}
class WishlistScreen extends StatelessWidget {
  final List<Map> wishlist;
  final Function removeFromWishlist;

  WishlistScreen({required this.wishlist, required this.removeFromWishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist')),
      body: wishlist.isEmpty
          ? Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return ListTile(
                  leading: Image.network(product['image']),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeFromWishlist(product); 
                      Navigator.pop(context); // 
                    },
                  ),
                );
              },
            ),
    );
  }
}
