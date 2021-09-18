import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/models/models.dart';
import 'package:crud/providers/providers.dart';
import 'package:crud/screens/screens.dart';
import 'package:crud/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final productsProvider = Provider.of<ProductsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false );

    if ( productsProvider.isLoading ) return LoadingScreen();

    final products = productsProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton( 
            icon: Icon( Icons.login_outlined ),
            onPressed: (){
              authProvider.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () {

            productsProvider.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard( products[ index ] )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: (){
          productsProvider.selectedProduct = 
              new Product(
                available: true, 
                name: '', 
                price: 0
              );
          Navigator.pushNamed(context, 'product');
        },
      )
    );
  }
}
