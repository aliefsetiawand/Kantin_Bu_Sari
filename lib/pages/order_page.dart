import 'package:flutter/material.dart';
import '../state/cart_state.dart';
import '../utils/format.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _bawaPulang = false;
  String _bayar = 'Tunai';
  final _nama = TextEditingController();

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  Future<void> _konfirmasi() async {
    if (_nama.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi nama pemesan dulu ya')));
      return;
    }
    // WIDGET: AlertDialog konfirmasi
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi pesanan'),
        content: Text(
          'Total ${rupiah(cart.totalHarga)} dibayar via $_bayar. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Pesan'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final struk = {
      'nama': _nama.text.trim(),
      'items': List<CartLine>.from(cart.items),
      'total': cart.totalHarga,
      'mode': _bawaPulang ? 'Bawa pulang' : 'Makan di tempat',
      'bayar': _bayar,
    };
    cart.kosongkan();
    Navigator.pushReplacementNamed(context, '/sukses', arguments: struk);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Kantin Bu Sari - Pesanan Kamu')),
          body: cart.items.isEmpty
              ? const Center(child: Text('Keranjang masih kosong 🛒'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    // WIDGET 1-3: Dismissible (geser untuk hapus) + Card + qty control
                    ...cart.items.map(
                      (line) => Dismissible(
                        key: ObjectKey(line),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => cart.hapus(line),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Text(
                              line.menu.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                            title: Text(line.menu.nama),
                            subtitle: Text(
                              '${line.catatan}\n${rupiah(line.subtotal)}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.ubahQty(line, -1),
                                ),
                                Text(
                                  '${line.qty}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.ubahQty(line, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    // WIDGET 4: TextField nama
                    TextField(
                      controller: _nama,
                      decoration: const InputDecoration(
                        labelText: 'Nama pemesan',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // WIDGET 5: Switch
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Bawa pulang'),
                      subtitle: Text(
                        _bawaPulang ? 'Dibungkus' : 'Makan di tempat',
                      ),
                      value: _bawaPulang,
                      onChanged: (v) => setState(() => _bawaPulang = v),
                    ),
                    // WIDGET 6: Dropdown metode bayar
                    DropdownButtonFormField<String>(
                      value: _bayar,
                      decoration: const InputDecoration(
                        labelText: 'Metode pembayaran',
                        prefixIcon: Icon(Icons.payments),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Tunai', 'QRIS', 'Transfer']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _bayar = v ?? 'Tunai'),
                    ),
                  ],
                ),
          bottomNavigationBar: cart.items.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Total'),
                              Text(
                                rupiah(cart.totalHarga),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(160, 52),
                          ),
                          onPressed: _konfirmasi,
                          child: const Text('Pesan Sekarang'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
