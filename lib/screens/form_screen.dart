import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var url = Uri.https('dummyjson.com', 'products/add');

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredDescription = '';
  var _enteredRating = '0.0';
  var _enterdPrice = '0';
  var _enterdDiscount = '0';
  var _enterdModel = '';
  var _selectedCategory = 'Smartphone';
  var _sendingRequest = false;

  void _submit() {
    setState(() {
      _sendingRequest = true;
    });
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      final productData = {
        'title': _enteredTitle,
        'description': _enteredDescription,
        'rating': double.parse(_enteredRating),
        'price': double.parse(_enterdPrice),
        'discountPercentage': double.parse(_enterdDiscount),
        'model': _enterdModel,
        'category': _selectedCategory,
      };
      sendProduct(productData);
    }
  }

  Future<void> sendProduct(Map<String, dynamic> productData) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(productData);

    try {
      await http.post(url, headers: headers, body: body);
      // ignore: avoid_print
      print("request sent.");
      _form.currentState!.reset();
    } catch (error) {
      // ignore: avoid_print
      print('Error sending request: $error');
    }
    setState(() {
      _sendingRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add product to catalogue",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter Title";
                    }
                    if (value.trim().length < 4) {
                      return "Title should be atleast 4 characters long";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter Description";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredDescription = newValue!;
                  },
                  maxLines: 3,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Rating'),
                        validator: (value) {
                          if (value == null) {
                            return "Enter Rating";
                          }
                          if (double.parse(value) < 0 ||
                              double.parse(value) > 10) {
                            return "Rating should lie in range 0-10";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredRating = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter Price";
                          }
                          if (double.parse(value) < 0) {
                            return "Enter valid Price";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterdPrice = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Discount'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter Discount";
                          }
                          if (double.parse(value) < 0 ||
                              double.parse(value) > 100) {
                            return 'Enter valid discount';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterdDiscount = newValue!;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Model'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter Model";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterdModel = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(label: Text("Category")),
                        value: _selectedCategory,
                        hint: const Text("Select an option"),
                        items: const [
                          DropdownMenuItem(
                              value: "Smartphone", child: Text("Smartphone")),
                          DropdownMenuItem(
                              value: "Smartwatch", child: Text("Smartwatch")),
                          DropdownMenuItem(
                              value: "Headphone", child: Text("Headphone")),
                        ],
                        onChanged: (value) {
                          _selectedCategory = value!;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _sendingRequest ? null : _submit,
                    child: _sendingRequest
                        ? const CircularProgressIndicator()
                        : const Text("Submit")),
              ],
            ),
          ),
        )));
  }
}
