import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sausage_shop/components/bottom_nav_bar.dart';
import 'package:sausage_shop/constant.dart';
import 'package:sausage_shop/screens/shop/bloc/shop_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sausage_shop/viewmodels/sausage_view_model.dart';

import '../../components/dialog.dart';
import '../../utils/event_bus.dart';
import '../cart/bloc/cart_bloc.dart';

/* This Screen describes the shop details of the sausages Where user can select orders,
eat in type and orders in the cart */

class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopBloc>(
      create: (context) => ShopBloc()..add(ShopInitial()),
      child: Scaffold(
        body: BlocBuilder<ShopBloc, ShopState>(
          builder: (context, state) {
            if (state is ShopInitialState) {
              return _loadingView(context); // Loading Indicator
            } else if (state is NoDataState) {
              return _errorDataView(context, state.msg); // Display Error View
            } else if (state is ShopLoaded) {
              return _loadedData(
                  context, state.sausageRollModel); //Loading data
            } else if (state is SausageCartState) {
              _showResultDialog(context, state.isSuccess); //Displaying popup
              final shopBloc = BlocProvider.of<ShopBloc>(context);
              return _loadedData(context, shopBloc.sausageRollViewModel);
            } else {
              return _errorDataView(context, "No data"); // Error data
            }
          },
        ),
      ),
    );
  }

  //SHowing popup message
  _showResultDialog(BuildContext context, bool isSuccess) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isSuccess) {
        eventBus.fire(
            const RefreshCarts()); //refreshing the carts when sausage added here
        showSnackBar(context, 'Sausage added successfully!');
        Navigator.pop(context);
      } else {
        showSnackBar(context, 'Failed to add sausage');
      }
    });
  }

  //Loading indicator
  _loadingView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Please wait while menu is loading',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            semanticsLabel: 'Circular progress indicator',
          ),
        ],
      ),
    );
  }

  // Error view if erros while fetching data
  _errorDataView(BuildContext context, String msg) {
    return Center(
      child: Text(
        msg,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  // Loading data fetched from bloc
  _loadedData(BuildContext context, SausageRollViewModel sausageRollModel) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: sausageRollModel.imgUrl,
          ),
        ),
        _topImageWidget(context),
        _scrollWidgets(context, sausageRollModel),
      ],
    );
  }

  // Top Image View
  _topImageWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 10),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 55,
              width: 55,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55 / 2),
                  color: Colors.transparent,
                ),
                child:
                    const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Scrolling whole view
  _scrollWidgets(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollcontroller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              controller: scrollcontroller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _displayDataWidget(context, sausageRollViewModel),
              ),
            ),
          );
        });
  }

  // Data display
  _displayDataWidget(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    final List<Widget> dataWidgets =
        _dataSausageDisplayWidgets(context, sausageRollViewModel);
    dataWidgets.addAll([
      _eatTypeWidget(context, sausageRollViewModel),
      const SizedBox(height: 20),
      _orderWidget(context, sausageRollViewModel),
      _addToCartWidget(context, sausageRollViewModel)
    ]);
    return dataWidgets;
  }

  // upper layer data display with no change in UI
  _dataSausageDisplayWidgets(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 35,
              color: Colors.black12,
            )
          ],
        ),
      ),
      Text("Greggs Shop - ${sausageRollViewModel.shopCode}",
          style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 10),
      Text(
        "${sausageRollViewModel.itemName} (${sausageRollViewModel.itemCode})",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: secondaryText),
      ),
      const SizedBox(height: 15),
      Row(
        children: [
          CachedNetworkImage(
            imageUrl: sausageRollViewModel.thumbImgUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 25,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              sausageRollViewModel.availabilityDetail,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: mainText),
            ),
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Divider(
          height: 4,
        ),
      ),
      Text(
        "Description (${sausageRollViewModel.internalDesc})",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Center(
        // color: Colors.amber,
        child: Text(
          sausageRollViewModel.customerDesc,
          style:
              const TextStyle(height: 1.2, color: secondaryText, fontSize: 15),
          textAlign: TextAlign.justify,
        ),
      )
    ];
  }

  // Eat type widget - State changes occurs
  _eatTypeWidget(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Eat options:", style: Theme.of(context).textTheme.bodyLarge!),
            MySwitchBar(
              selectedIndex: sausageRollViewModel.isSelectedEatInType ? 0 : 1,
              onTabChange: (index) => _eatAction(context, index),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
            "Price: ${sausageRollViewModel.isSelectedEatInType ? sausageRollViewModel.eatInPrice : sausageRollViewModel.eatOutPrice} GBP / ${sausageRollViewModel.itemName}",
            style: Theme.of(context).textTheme.bodyLarge!),
      ],
    );
  }

  // Order widget - State changes occurs
  _orderWidget(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Order Quantity: ", style: Theme.of(context).textTheme.bodyLarge!),
        IconButton(
            onPressed: () => sausageRollViewModel.orderQty == 0
                ? null
                : _orderQtyPressed(context, false),
            icon: const Icon(Icons.remove)),
        const SizedBox(width: 15),
        Text('${sausageRollViewModel.orderQty}',
            style: Theme.of(context).textTheme.bodyLarge!),
        const SizedBox(width: 15),
        IconButton(
            onPressed: () => _orderQtyPressed(context, true),
            icon: const Icon(Icons.add)),
      ],
    );
  }

  // Saving the data
  _addToCartWidget(
      BuildContext context, SausageRollViewModel sausageRollViewModel) {
    final priceToConsider = sausageRollViewModel.isSelectedEatInType
        ? sausageRollViewModel.eatInPrice
        : sausageRollViewModel.eatOutPrice;
    final totalPrice = priceToConsider * sausageRollViewModel.orderQty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            if (sausageRollViewModel.orderQty == 0) {
              showSnackBar(context,
                  'There should be atleast one order quantiy to add in the cart');
            } else {
              _addToCartAction(context);
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          child: Text(
            'Add to Cart ${totalPrice == 0 ? "" : "(${totalPrice.toStringAsFixed(2)} GBP)"}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  // Trigger event based on eattype
  void _eatAction(BuildContext context, int index) {
    context.read<ShopBloc>().add(
        ShopEatChangeEvent(isSelectedEatInType: index == 0 ? true : false));
  }

  // Trigger event based on orders
  void _orderQtyPressed(BuildContext context, bool toIncrement) {
    context.read<ShopBloc>().add(OrderQtyChangeEvent(isIncrement: toIncrement));
  }

  // Trigger event based on saving sausage
  void _addToCartAction(BuildContext context) {
    context.read<ShopBloc>().add(const AddSausageEvent());
  }
}
