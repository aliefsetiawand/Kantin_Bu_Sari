import 'package:flutter/material.dart';
import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../state/cart_state.dart';
import '../utils/format.dart';
import 'menu_detail_page.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  String _kategori = 'Semua';
  String _cari = '';

  void _tambahCepat(MenuItem m) {
    cart.tambah(m);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${m.nama} masuk keranjang'),
        action: SnackBarAction(
          label: 'LIHAT',
          onPressed: () => Navigator.pushNamed(context, '/pesan'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil = daftarMenu.where((m) {
      final cocokKategori = _kategori == 'Semua' || m.kategori == _kategori;
      final cocokCari = m.nama.toLowerCase().contains(_cari.toLowerCase());
      return cocokKategori && cocokCari;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kantin Bu Sari')),
      body: Column(
        children: [
          // WIDGET 1: TextField pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _cari = v),
              decoration: InputDecoration(
                hintText: 'Mau makan apa hari ini?',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // WIDGET 2: ChoiceChip filter kategori (scroll horizontal)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: kategoriList
                  .map(
                    (k) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(k),
                        selected: _kategori == k,
                        onSelected: (_) => setState(() => _kategori = k),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // WIDGET 3-5: ListView + Card + ListTile + CircleAvatar
          Expanded(
            child: hasil.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan 😢'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: hasil.length,
                    itemBuilder: (context, i) {
                      final m = hasil[i];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Hero(
                            tag: 'emoji-${m.id}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.orange.shade50,
                                child: Text(
                                  m.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            m.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${m.kategori} • ${rupiah(m.harga)}'),
                          trailing: IconButton.filledTonal(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () => _tambahCepat(m),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MenuDetailPage(menu: m),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // WIDGET 6: FAB + Badge, ikut berubah saat keranjang berubah
      floatingActionButton: ListenableBuilder(
        listenable: cart,
        builder: (context, _) => FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/pesan'),
          icon: Badge(
            label: Text('${cart.totalItem}'),
            isLabelVisible: cart.totalItem > 0,
            child: const Icon(Icons.shopping_cart),
          ),
          label: const Text('Keranjang'),
        ),
      ),
    );
  }
}
