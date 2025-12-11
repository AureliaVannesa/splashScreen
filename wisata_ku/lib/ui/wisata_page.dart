import 'package:flutter/material.dart';
import 'package:wisata_ku/bloc/logout_bloc.dart';
import 'package:wisata_ku/bloc/wisata_bloc.dart';
import 'package:wisata_ku/model/wisata.dart';
import 'package:wisata_ku/ui/login_page.dart';
import 'package:wisata_ku/ui/detail_wisata.dart';
import 'package:wisata_ku/ui/tambah_wisata.dart';

// --- DEFINISI WARNA DAN WIDGET UTAMA ---
const Color primaryAccent = Color(0xFF7E57C2); // Ungu elegan
const Color softBackground = Color(0xFFF3E5F5); // Ungu lembut

class WisataPage extends StatefulWidget {
  const WisataPage({Key? key}) : super(key: key);

  @override
  _WisataPageState createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Wisata',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryAccent,
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              size: 28.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WisataForm()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primaryAccent),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: primaryAccent),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Wisata>>(
        future: WisataBloc.getWisata(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryAccent),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data wisata.'));
          }
          return ListWisata(list: snapshot.data!);
        },
      ),
    );
  }
}

// --- WIDGET LIST WISATA ---
class ListWisata extends StatelessWidget {
  final List<Wisata> list;

  const ListWisata({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: list.length,
      itemBuilder: (context, i) {
        return ItemWisata(wisata: list[i]);
      },
    );
  }
}

// --- ITEM WISATA ---
class ItemWisata extends StatelessWidget {
  final Wisata wisata;

  const ItemWisata({Key? key, required this.wisata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WisataDetail(wisata: wisata),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.place_outlined,
                      color: primaryAccent,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wisata.namaWisata ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wisata.lokasi ?? '-',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Rp ${wisata.hargaTiket ?? 0}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: primaryAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: softBackground, thickness: 1),
      ],
    );
  }
}
