class Wisata {
  int? id;
  String? kodeWisata;
  String? namaWisata;
  String? lokasi;
  int? hargaTiket;
  String? deskripsi;

  Wisata({
    this.id,
    this.kodeWisata,
    this.namaWisata,
    this.lokasi,
    this.hargaTiket,
    this.deskripsi,
  });

  factory Wisata.fromJson(Map<String, dynamic> obj) {
    return Wisata(
      id: obj['id'] is String ? int.tryParse(obj['id']) : obj['id'],
      kodeWisata: obj['kode_wisata'],
      namaWisata: obj['nama_wisata'],
      lokasi: obj['lokasi'],
      hargaTiket: obj['harga_tiket'] is String
          ? int.tryParse(obj['harga_tiket'])
          : obj['harga_tiket'],
      deskripsi: obj['deskripsi'],
    );
  }
}
