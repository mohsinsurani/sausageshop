import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sausage_shop/components/dialog.dart';
import 'package:sausage_shop/screens/cart/bloc/cart_bloc.dart';
import 'package:sausage_shop/viewmodels/sausage_view_model.dart';
import 'package:sausage_shop/screens/shop/shop_detail_screen.dart';

/* Cart list screen where User will see the list of the sausage rolls
added from the shop detail screen */

class CartListScreen extends StatelessWidget {
  const CartListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart list',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0.0, backgroundColor: Colors.red.withOpacity(0)),
            onPressed: () {
              _addSausage(context); // Navigating to Shop detail screen
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
        // You can customize the app bar further here
      ),
      body: BlocProvider(
        create: (context) => CartBloc()..add(CartInitialEvent()),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartInitial) {
              return const CircularProgressIndicator(); // loading indicator
            } else if (state is CartLoaded && state.sausageList.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  final cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(
                      const RefreshCarts()); // refreshing carts on pull refresh
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Sausages to buy",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              onPressed: () {
                                final cartBloc =
                                    BlocProvider.of<CartBloc>(context);
                                cartBloc.add(ClearItems()); // clearing data
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.sausageList.length,
                            itemBuilder: ((context, index) =>
                                _cartCard(context, state.sausageList[index]))),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showSnackBar(context,
                                'This feature is currently under implementation');
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ), // Replace with your icon
                          label: Text(
                            'Checkout (${state.sausageList.totalPrice.toStringAsFixed(2)} GBP)',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: Colors.blue, // Change button color
                            padding: const EdgeInsets.symmetric(
                                vertical: 16), // Adjust button padding
                          ),
                        ),
                      )
                    ]),
              );
            } else {
              return const Center(child: Text("No Sausages in the cart"));
            }
          },
        ),
      ),
    );
  }

  // navigating to shop detail screen
  _addSausage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShopDetailScreen()),
    );
  }

  // A kind of List tile - Card which can be deleted
  _cartCard(BuildContext context, SausageRollViewModel sausageRollViewModel) {
    return Dismissible(
      key: UniqueKey(), // Unique key for each Dismissible widget
      direction: DismissDirection.endToStart, // Swipe direction for dismissal
      onDismissed: (direction) {
        // Here, you can add code to delete the item from the list
        context
            .read<CartBloc>()
            .add(RemoveItems(sausageRollViewModel: sausageRollViewModel));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                //Caching the image downloaded
                imageUrl: sausageRollViewModel.thumbImgUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 25,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleWidget(sausageRollViewModel.itemName,
                      " (${sausageRollViewModel.isSelectedEatInType ? "Eat-In" : "Take-Away"}}"),
                  _detailWidget(
                      "Quantity: ", sausageRollViewModel.orderQty.toString()),
                  _detailWidget("Total price: ",
                      "${sausageRollViewModel.totalPrice.toStringAsFixed(2)} GBP"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Title and detail widget formation
  _titleWidget(String title, String detail) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  // Title and detail re-usable widget formation
  _detailWidget(String title, String detail) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
