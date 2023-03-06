import 'package:flutter/material.dart';
import 'package:food/logger.dart';
import 'package:food/model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  List<OrderSummary> _itemsList = [];
  @override
  void initState() {
    super.initState();
    fetchOrderSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<OrderSummary>(
          future: fetchOrderSummary(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orderSummary = snapshot.data!;
              return Stack(children: [
                Container(
                  width: 500,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 120,
                      left: 20,
                    ),
                    child: Row(children: const [
                      Text(
                        "Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 160),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Subtotal',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 150,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(' \$${orderSummary.subtotal}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Tax',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 200),
                                    child: Text('\$${orderSummary.tax}'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("Delivery Fee:",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 140),
                                    child:
                                        Text('\$${orderSummary.deliveryfee}'),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Total:',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 160),
                                    child: Text('\$${orderSummary.total}',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ])),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 370,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: orderSummary.items.length,
                      itemBuilder: (context, index) {
                        final item = orderSummary.items[index];
                        return ListTile(
                          leading: Image.network(item.imageUrl),
                          title: Text(item.name),
                          subtitle: Text(item.description),
                          trailing: Text('\$${item.amount}'),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 660, left: 60),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Checkout", style: TextStyle(fontSize: 28)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 60, left: 50)),
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

Future<OrderSummary> fetchOrderSummary() async {
  final response = await http.get(Uri.parse(
      'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/pravalika/getdata'));
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> itemsList = jsonResponse['data']['items'];
    logger.d(response.body.toString);
    return OrderSummary.fromJson(
      json.decode(response.body),
    );

    //  logger.d(response);
    //  logger.d("response data");
  } else {
    throw Exception('Failed to fetch order summary');
  }
}
