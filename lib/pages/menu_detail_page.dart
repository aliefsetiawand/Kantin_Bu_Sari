import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../state/cart_state.dart';
import '../utils/format.dart';

class MenuDetailPage extends StatefulWidget {
  final MenuItem menu;
  const MenuDetailPage({super.key, required this.menu});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _qty = 1;
  String _pedas = 'Sedang';
  bool _telur = false;
  bool _besar = false;
  final _catatan = TextEditingController();

  int get _extra => (_telur ? 3000 : 0) + (_besar ? 5000 : 0);
  int get _total => (widget.menu.harga + _extra) * _qty;

  @override
  void dispose() {
    _catatan.dispose();
    super.dispose();
  }

  void _tambah() {
    final info = [
      'Pedas: $_pedas',
      if (_telur) '+Telur',
      if (_besar) 'Porsi besar',
      if (_catatan.text.trim().isNotEmpty) _catatan.text.trim(),
    ].join(', ');

    cart.tambah(widget.menu, qty: _qty, catatan: info, extra: _extra);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.menu.nama} x$_qty ditambahkan')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.menu;
    return Scaffold(
      appBar: AppBar(title: Text(m.nama)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // WIDGET 1: Hero (animasi transisi dari daftar menu)
          Center(
            child: Hero(
              tag: 'emoji-${m.id}',
              child: Material(
                type: MaterialType.transparency,
                child: Text(m.emoji, style: const TextStyle(fontSize: 96)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(m.deskripsi, textAlign: TextAlign.center),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Chip(label: Text(rupiah(m.harga))),
            ),
          ),
          const Divider(),
          // WIDGET 2: SegmentedButton level pedas
          const Text(
            'Level pedas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              'Tidak',
              'Sedang',
              'Pedas',
            ].map((e) => ButtonSegment(value: e, label: Text(e))).toList(),
            selected: {_pedas},
            onSelectionChanged: (s) => setState(() => _pedas = s.first),
          ),
          // WIDGET 3: CheckboxListTile
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tambah telur (+Rp 3.000)'),
            value: _telur,
            onChanged: (v) => setState(() => _telur = v ?? false),
          ),
          // WIDGET 4: SwitchListTile
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Porsi besar (+Rp 5.000)'),
            value: _besar,
            onChanged: (v) => setState(() => _besar = v),
          ),
          // WIDGET 5: TextField catatan
          TextField(
            controller: _catatan,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan untuk Bu Sari',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // WIDGET 6: Counter jumlah
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                icon: const Icon(Icons.remove),
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '$_qty',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _qty++),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Tambah ke keranjang • ${rupiah(_total)}'),
            onPressed: _tambah,
          ),
        ),
      ),
    );
  }
}
