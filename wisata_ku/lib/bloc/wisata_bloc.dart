import 'dart:convert';
import '../helpers/api.dart';
import '../helpers/api_url.dart';
import '../model/wisata.dart';

class WisataBloc {
  // GET semua data wisata
  static Future<List<Wisata>> getWisata() async {
    String apiUrl = ApiUrl.listWisata;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listWisata;

    if (jsonObj is List) {
      listWisata = jsonObj;
    } else if (jsonObj is Map && jsonObj.containsKey('data')) {
      listWisata = jsonObj['data'] as List<dynamic>;
    } else {
      throw Exception("Format data wisata tidak valid dari API.");
    }

    List<Wisata> wisata = [];
    for (int i = 0; i < listWisata.length; i++) {
      if (listWisata[i] != null) {
        wisata.add(Wisata.fromJson(listWisata[i] as Map<String, dynamic>));
      }
    }
    return wisata;
  }

  // CREATE wisata
  static Future addWisata({Wisata? wisata}) async {
    String apiUrl = ApiUrl.createWisata;
    var body = {
      "kode_wisata": wisata?.kodeWisata ?? '',
      "nama_wisata": wisata?.namaWisata ?? '',
      "lokasi": wisata?.lokasi ?? '',
      "harga_tiket": wisata?.hargaTiket?.toString() ?? '0',
      "deskripsi": wisata?.deskripsi ?? '',
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // UPDATE wisata
  static Future<bool> updateWisata({required Wisata wisata}) async {
    if (wisata.id == null) {
      throw Exception("ID wisata tidak boleh null saat update.");
    }

    String apiUrl = ApiUrl.updateWisata(wisata.id!);

    var body = {
      "kode_wisata": wisata.kodeWisata,
      "nama_wisata": wisata.namaWisata,
      "lokasi": wisata.lokasi,
      "harga_tiket": wisata.hargaTiket.toString(),
      "deskripsi": wisata.deskripsi,
    };

    print("Body : $body");
    var response = await Api().put(apiUrl, body);

    try {
      print('API Response status: ${response.statusCode}');
      print('API Response body: ${response.body}');
    } catch (e) {}

    try {
      var jsonObj = json.decode(response.body);
      return jsonObj['data'];
    } catch (e) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      rethrow;
    }
  }

  // DELETE wisata
  static Future<bool> deleteWisata({int? id}) async {
    if (id == null) {
      throw Exception("ID wisata tidak boleh null saat delete.");
    }

    String apiUrl = ApiUrl.deleteWisata(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == true;
  }
}
