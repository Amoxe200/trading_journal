import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_journal/widgets/input_card.dart';
import '../providers/trade_provider.dart';
import '../models/trade.dart';

class AddTradeScreen extends StatefulWidget {
  final Trade? trade;

  const AddTradeScreen({super.key, this.trade});

  @override
  _AddTradeScreenState createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends State<AddTradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tradeNameController = TextEditingController();
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.trade != null) {
      _tradeNameController.text = widget.trade!.tradeName;
      _entryPriceController.text = widget.trade!.entryPrice.toString();
      _exitPriceController.text = widget.trade!.exitPrice.toString();
      _quantityController.text = widget.trade!.quantity.toString();
      _notesController.text = widget.trade!.notes;
    }
  }

  void _saveTrade() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final trade = Trade(
      id: widget.trade?.id,
      tradeName: _tradeNameController.text,
      entryPrice: double.parse(_entryPriceController.text),
      exitPrice: double.parse(_exitPriceController.text),
      quantity: int.parse(_quantityController.text),
      date: DateTime.now().toString(),
      notes: _notesController.text,
    );

    if (widget.trade == null) {
      Provider.of<TradeProvider>(context, listen: false).insertTrade(trade);
    } else {
      Provider.of<TradeProvider>(context, listen: false).updateTrade(trade);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF33B49B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.trade == null ? 'Add Trade 📈' : 'Edit Trade ✏️',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputCard(
                    controller: _tradeNameController,
                    title: 'Trade Name',
                    validatorInfo: 'Please enter the trade name',
                    cardTile: 'Enter Trade Name 📝',
                    keyboardType: TextInputType.text,
                    icon: Icons.label_important,
                  ),
                  InputCard(
                    controller: _entryPriceController,
                    title: 'Entry Price',
                    cardTile: 'Enter Entry Price 📥',
                    validatorInfo: 'Please enter the entry price',
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money,
                  ),
                  InputCard(
                    controller: _exitPriceController,
                    title: 'Exit Price',
                    cardTile: 'Enter Exit Price 📤',
                    validatorInfo: 'Please enter the exit price',
                    keyboardType: TextInputType.number,
                    icon: Icons.monetization_on,
                  ),
                  InputCard(
                    controller: _quantityController,
                    title: 'Quantity',
                    cardTile: 'Enter Quantity 🔢',
                    validatorInfo: 'Please enter the quantity',
                    keyboardType: TextInputType.number,
                    icon: Icons.numbers,
                  ),
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note_alt, color: Color(0xFF33B49B)),
                              SizedBox(width: 8),
                              Text(
                                'Enter Notes 📝',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _notesController,
                            decoration: _getNotesInputDecoration(),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveTrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF33B49B),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          'Save Trade  💾',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _getNotesInputDecoration() {
  return InputDecoration(
    hintText: 'Add your trade notes here...',
    hintStyle: TextStyle(color: Colors.grey[500]),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF33B49B), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF33B49B), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}