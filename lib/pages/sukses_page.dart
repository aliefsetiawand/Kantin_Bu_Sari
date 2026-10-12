import 'package:flutter/material.dart';
import '../state/cart_state.dart';
import '../utils/format.dart';

class SuksesPage extends StatelessWidget {
  const SuksesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = (ModalRoute.of(context)?.settings.arguments ?? {}) as Map;
    final items = (data['items'] ?? <CartLine>[]) as List<CartLine>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Bu Sari - Pesanan Kamu'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // WIDGET 1: ikon centang beranimasi
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, v, child) =>
                  Transform.scale(scale: v, child: child),
              child: const Icon(
                Icons.check_circle,
                size: 96,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pesanan Kamu Diterima!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tunjukkan struk ini ke kasir Bu Sari.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // WIDGET 2-4: Card struk + Chip + ListTile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atas nama: ${data['nama'] ?? '-'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('${data['mode'] ?? '-'}')),
                      Chip(label: Text('${data['bayar'] ?? '-'}')),
                    ],
                  ),
                  const Divider(),
                  ...items.map(
                    (l) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('${l.qty}x ${l.menu.nama}'),
                      subtitle: Text(l.catatan),
                      trailing: Text(rupiah(l.subtotal)),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        rupiah((data['total'] ?? 0) as int),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // WIDGET 5: tombol kembali
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Kembali ke Daftar Menu'),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
