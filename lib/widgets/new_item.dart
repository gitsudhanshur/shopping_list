import 'dart:convert';

import 'package:shopping_list/data/categories.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/models/category.dart';
//import 'package:shopping_list/models/grocery_item.dart';

class  NewItem extends StatefulWidget{
  const NewItem({super.key});

  @override
  State<NewItem> createState(){
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() async{
if(_formKey.currentState!.validate()) {
_formKey.currentState!.save();
final url = Uri.https(
  'flutter-prep-fbe19-default-rtdb.firebaseio.com', 'shopping-list.json');
  final response = await http.post(
  url,
   headers: {
  'Content-Type': 'application/json',
},body: json.encode({
   'name': _enteredName,
    'quantity': _enteredQuantity,
    'category': _selectedCategory.title,
},
),
);
print (response.body);
print (response.statusCode);

if (!context.mounted){
  return;
}
  Navigator.of(context).pop();
   
  }
  }


@override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title:const Text('Add a new item'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 60,
              decoration: const InputDecoration(
                label: Text ('Name'),
              ),
              validator: (value){
                if (value == null ||
                 value.isEmpty ||
                  value.trim().length <= 1  ||
                   value.trim().length> 50){
                    return 'must be between 1 and 50 characters.';
                   }
                return null;
              },
              onSaved: (value){
                //if (value == null){
                 // return;
               // }
                _enteredName = value!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
               child: TextFormField(
                  decoration: const InputDecoration(
                    label:Text('Quantity'),
      
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _enteredQuantity.toString(),
                    validator: (value){
                if (value == null ||
                 value.isEmpty ||
                  int.tryParse(value) == null ||
                  int.tryParse(value)! <= 0) {
                    return 'must be a valid, positive number.';
                   }
                return null;
              },
              onSaved: (value){
                _enteredQuantity =int.parse(value!);
              },
                ),
                ),
                const SizedBox(width: 8),
               Expanded(
               child:  DropdownButtonFormField(
               value: _selectedCategory,
                items: [
                  for(final Category in categories.entries)
                  DropdownMenuItem(
                    value: Category.value,
                    child: Row(
                      children:[
                      Container(
                        width: 16,
                        height: 16,
                        color: Category.value.color,
                      ),
                      const SizedBox(width: 6),
                      Text(Category.value.title),
                      ]
                    ),
                    ),
                ],
                 onChanged: (value) {
                  setState(() {
                     _selectedCategory = value!;
                  });
                  
                },
                ),
               ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _formKey.currentState!.reset();
                  },
                   child:  const Text('Reset'),
                   ),
                ElevatedButton(
                  onPressed: _saveItem,
                   child: const Text('Add Item'),
                   ),
              ],
            )
          ],
        ),
      ),
    ),
   ); 
    
  }
}