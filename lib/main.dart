import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>  MenuScreen(title: 'Menu'),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/detail': (context) => const DetailScreen(),
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final String title;

   MenuScreen({Key? key, required this.title}) : super(key: key);

  // Sample menu items
  final List<MenuItem> menuItems = [
    MenuItem('Pizza', 'Delicious cheese pizza', '\$10', Icons.local_pizza),
    MenuItem('Burger', 'Juicy beef burger', '\$8', Icons.fastfood),
    MenuItem('Pasta', 'Creamy pasta', '\$12', Icons.restaurant),
    MenuItem('Salad', 'Fresh salad', '\$6', Icons.local_dining),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(menuItems[index].icon, size: 50),
            title: Text(menuItems[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(menuItems[index].description),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: menuItems[index], // Pass the selected menu item as argument
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MenuItem menuItem = ModalRoute.of(context)!.settings.arguments as MenuItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              menuItem.title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              menuItem.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ${menuItem.price}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CartProvider.of(context).addToCart(menuItem);
                Navigator.pushNamed(context, '/cart');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartProvider.of(context).cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].title),
            subtitle: Text(cartItems[index].description),
            trailing: Text(cartItems[index].price),
            onTap: () {
              CartProvider.of(context).removeFromCart(cartItems[index]);
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${CartProvider.of(context).calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Simulate payment process
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Payment Confirmation'),
                        content: const Text('Your order has been placed.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.popUntil(context, ModalRoute.withName('/'));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String description;
  final String price;
  final IconData icon;

  MenuItem(this.title, this.description, this.price, this.icon);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _validUsername = 'App123';
  final String _validPassword = 'Admin123';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_usernameController.text == _validUsername &&
                      _passwordController.text == _validPassword) {
                    Navigator.popAndPushNamed(context, '/');
                  } else {
                    _errorMessage = 'Invalid username or password';
                  }
                });
              },
              child: const Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate registration
            // Replace with actual registration logic
            Navigator.popAndPushNamed(context, '/');
          },
          child: const Text('Register'),
        ),
      ),
    );
  }
}

class CartProvider extends InheritedWidget {
  final List<MenuItem> cartItems = [];

  CartProvider({Key? key, required Widget child}) : super(key: key, child: child);

  void addToCart(MenuItem item) {
    cartItems.add(item);
  }

  void removeFromCart(MenuItem item) {
    cartItems.remove(item);
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += double.parse(item.price.replaceAll('\$', ''));
    }
    return totalPrice;
  }

  static CartProvider of(BuildContext context) {
    final CartProvider? result = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(result != null, 'No CartProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CartProvider oldWidget) {
    return oldWidget.cartItems != cartItems;
  }
}
