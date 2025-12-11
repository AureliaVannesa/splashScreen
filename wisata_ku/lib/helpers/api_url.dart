class ApiUrl {
  static const String baseUrl = 'http://localhost:8080';

  // AUTH
  static const String registrasi = "$baseUrl/registrasi";
  static const String login = "$baseUrl/login";

  // PRODUK
  static const String listProduk = "$baseUrl/produk";
  static const String createProduk = "$baseUrl/produk";

  // WISATA
  static const String listWisata = "$baseUrl/wisata";
  static const String createWisata = "$baseUrl/wisata";
  static String updateWisata(int id) => "$baseUrl/wisata/$id";
  static String deleteWisata(int id) => "$baseUrl/wisata/$id";
}
