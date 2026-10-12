import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartLine {
  final MenuItem menu;
  final String catatan;
  final int hargaSatuan;
  int qty;

  CartLine({
    required this.menu,
    required this.catatan,
    required this.hargaSatuan,
    required this.qty,
  });

  int get subtotal => hargaSatuan * qty;
}

class CartState extends ChangeNotifier {
  final List<CartLine> items = [];

  int get totalItem => items.fold(0, (s, e) => s + e.qty);
  int get totalHarga => items.fold(0, (s, e) => s + e.subtotal);

  void tambah(MenuItem m, {int qty = 1, String catatan = '', int extra = 0}) {
    final i = items.indexWhere(
      (e) => e.menu.id == m.id && e.catatan == catatan,
    );
    if (i >= 0) {
      items[i].qty += qty;
    } else {
      items.add(
        CartLine(
          menu: m,
          catatan: catatan,
          hargaSatuan: m.harga + extra,
          qty: qty,
        ),
      );
    }
    notifyListeners();
  }

  void ubahQty(CartLine l, int delta) {
    l.qty += delta;
    if (l.qty <= 0) items.remove(l);
    notifyListeners();
  }

  void hapus(CartLine l) {
    items.remove(l);
    notifyListeners();
  }

  void kosongkan() {
    items.clear();
    notifyListeners();
  }
}

// Satu keranjang yang dipakai semua halaman
final cart = CartState();
