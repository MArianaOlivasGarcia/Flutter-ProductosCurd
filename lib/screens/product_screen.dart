


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:crud/ui/input_decorations.dart';
import 'package:crud/providers/providers.dart';
import 'package:crud/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsProvider =  Provider.of<ProductsProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider( productsProvider.selectedProduct ),
      child: _ProductScreenBody(
        productsProvider: productsProvider,
      ),
    );

  }

}

class _ProductScreenBody extends StatelessWidget {

  const _ProductScreenBody({
    required this.productsProvider,
  });

  final ProductsProvider productsProvider;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [
                ProductImage( 
                  url: productsProvider.selectedProduct.picture,  
                ),

                Positioned(
                  top: 30,
                  left: 15,
                  child: IconButton(
                    icon: Icon( Icons.arrow_back_ios_new,
                      color: Colors.white
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ),

                Positioned(
                  top: 30,
                  right: 15,
                  child: IconButton(
                    icon: Icon( Icons.camera_alt_outlined,
                      color: Colors.white
                    ),
                    onPressed: () async {
                      // CAMARA O GALERIA
                      final picker = new ImagePicker();
                      final XFile? xFile = await picker.pickImage(
                        // source: ImageSource.gallery
                        source: ImageSource.camera,
                        imageQuality: 100
                      );

                      if ( xFile == null ) {
                        return;
                      }
                      
                      productsProvider.updateSelectedProductImage( xFile.path );

                    },
                  )
                )

              ],
            ),

            _ProductForm(),

            SizedBox(
              height: 70,
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: productsProvider.isSaving
          ? CircularProgressIndicator(
            color: Colors.white
          )
          : Icon( Icons.save_outlined ),
        onPressed: productsProvider.isSaving
          ? null
          : () async {
          // Guardar producto
          if ( !productForm.isValidForm() )  return;
  
          final String? imageUrl = await productsProvider.uploadImage();
          if ( imageUrl != null ) productForm.product.picture = imageUrl;

          await productsProvider.saveOrCreateProduct( productForm.product );
        },
      ),
    );
  }
}



class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10
        ),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [

              SizedBox(
                height: 10,
              ),

              TextFormField(
                initialValue: product.name,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:'
                ),
                onChanged: ( value ) => product.name = value,
                validator: ( value ){
                  if ( value == null || value.length < 1 ){
                    return 'El nombre es obligatorio';
                  }
                },
              ),

              SizedBox(
                height: 30,
              ),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio:'
                ),
                onChanged: ( value ){
                  double.tryParse(value) == null 
                    ? product.price = 0
                    : product.price = double.parse(value);
                }
              ),

              SizedBox(
                height: 30,
              ),

              SwitchListTile.adaptive(
                value: product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                // onChanged: ( value ) => productForm.updateAvailability(value)
                onChanged: productForm.updateAvailability
              ),

              SizedBox(
                height: 30,
              ),

            ],
          )
        )
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(25),
      bottomLeft: Radius.circular(25)
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,0),
        blurRadius: 5
      )
    ]
  );

}