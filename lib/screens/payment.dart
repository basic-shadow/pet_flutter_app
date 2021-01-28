import 'package:ecommerce_app/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentDetails extends StatefulWidget {
  PaymentDetails(this.product, this._controller, this._quantity);
  final Product product;
  final PageController _controller;
  final int _quantity;

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  String totalPrice;
  bool completed = false;

  void _pay() {
    InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-ef7HTPbK38sCAZCTJY94rg');
    InAppPayments.startCardEntryFlow(
      onCardEntryCancel: _cardEntryCancel,
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    );
  }

  void _cardEntryCancel() {
    // Cancel
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Wrong Card Details"),
      duration: Duration(milliseconds: 1200),
    ));
  }

  void _cardEntryComplete() {
    // Success
    setState(() => completed = true);
  }

  void _cardNonceRequestSuccess(CardDetails result) {
    // Use this nonce from your backend to pay via Square API
    print(result.nonce);

    final bool _invalidZipCode = false;

    if (_invalidZipCode) {
      // Stay in the card flow and show an error:
      InAppPayments.showCardNonceProcessingError('Invalid ZipCode');
    }

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  @override
  void initState() {
    super.initState();
    int price = int.parse(widget.product.price.substring(1)) * widget._quantity;
    totalPrice = widget.product.price.substring(0, 1) + price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: completed
          ? Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Transaction Successfull"),
                    FlatButton(
                      child: Text(
                        "Go Homepage",
                        style: TextStyle(color: Colors.blue[700], fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                    )
                  ]),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Checkout",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              width: 30,
                              child: Text(
                                "1",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border:
                                    Border.all(width: 2.0, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Shipping Address",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              width: 30,
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.teal[600],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Payment Details",
                                style: TextStyle(
                                    color: Colors.teal[400], fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.8,
                  margin: EdgeInsets.only(top: 25.0),
                  child: Container(height: 0.8, color: Colors.grey[300]),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(0, 0.8),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Details",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                Container(
                  height: 0.8,
                  margin: EdgeInsets.all(13.0),
                  child: Container(height: 0.8, color: Colors.grey[300]),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(0, 0.8),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.title,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Row(
                        children: [
                          Text(
                            widget._quantity.toString() + "  x",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(width: 15),
                          Text(
                            widget.product.price,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.8,
                  margin: EdgeInsets.all(13.0),
                  child: Container(height: 0.8, color: Colors.grey[300]),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(0, 0.8),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Order",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(totalPrice,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.teal[700]))
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                width: 2, color: Colors.blueGrey[300])),
                        child: FlatButton(
                          onPressed: () {
                            widget._controller.animateToPage(
                              0,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text("Back to Cart"),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[600],
                            borderRadius: BorderRadius.circular(20.0)),
                        child: FlatButton(
                          onPressed: _pay,
                          child: Text("PAY",
                              style: Theme.of(context).textTheme.headline5),
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
