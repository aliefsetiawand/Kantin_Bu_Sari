import '../models/menu_item.dart';

const kategoriList = ['Semua', 'Makanan', 'Minuman', 'Camilan'];

const daftarMenu = [
  MenuItem(
    id: 'm1',
    nama: 'Nasi Goreng Bu Sari',
    kategori: 'Makanan',
    emoji: '🍛',
    harga: 15000,
    deskripsi: 'Nasi goreng bumbu rahasia dengan ayam suwir dan kerupuk.',
  ),
  MenuItem(
    id: 'm2',
    nama: 'Mie Ayam Bakso',
    kategori: 'Makanan',
    emoji: '🍜',
    harga: 14000,
    deskripsi: 'Mie kenyal, ayam kecap, dan bakso sapi.',
  ),
  MenuItem(
    id: 'm3',
    nama: 'Ayam Geprek',
    kategori: 'Makanan',
    emoji: '🍗',
    harga: 16000,
    deskripsi: 'Ayam crispy digeprek dengan sambal bawang.',
  ),
  MenuItem(
    id: 'm4',
    nama: 'Es Teh Manis',
    kategori: 'Minuman',
    emoji: '🧋',
    harga: 4000,
    deskripsi: 'Teh manis dingin yang menyegarkan.',
  ),
  MenuItem(
    id: 'm5',
    nama: 'Es Jeruk',
    kategori: 'Minuman',
    emoji: '🍹',
    harga: 6000,
    deskripsi: 'Jeruk peras asli dengan es batu.',
  ),
  MenuItem(
    id: 'm6',
    nama: 'Gorengan (3 pcs)',
    kategori: 'Camilan',
    emoji: '🍤',
    harga: 5000,
    deskripsi: 'Tempe, tahu, dan bakwan goreng hangat.',
  ),
  MenuItem(
    id: 'm7',
    nama: 'Pisang Cokelat',
    kategori: 'Camilan',
    emoji: '🍌',
    harga: 7000,
    deskripsi: 'Pisang goreng dengan lelehan cokelat.',
  ),
];
