import 'package:flutter/material.dart';
import 'package:wisata_ku/model/wisata.dart';
import 'package:wisata_ku/ui/tambah_wisata.dart';

import '../bloc/wisata_bloc.dart';
import '../widget/warning_dialog.dart';
import 'wisata_page.dart';

class WisataDetail extends StatefulWidget {
  final Wisata? wisata;

  const WisataDetail({Key? key, this.wisata}) : super(key: key);

  @override
  _WisataDetailState createState() => _WisataDetailState();
}

class _WisataDetailState extends State<WisataDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Detail Wisata',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Kode Wisata: ${widget.wisata!.kodeWisata}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nama Wisata: ${widget.wisata!.namaWisata}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Lokasi: ${widget.wisata!.lokasi}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Harga Tiket: Rp ${widget.wisata!.hargaTiket}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Deskripsi :  ${widget.wisata!.deskripsi}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  _tombolHapusEdit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Edit
        ElevatedButton.icon(
          icon: const Icon(Icons.edit, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: const Text(
            "EDIT",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WisataForm(wisata: widget.wisata!),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        // Tombol Hapus
        ElevatedButton.icon(
          icon: const Icon(Icons.delete, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[700],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        "Konfirmasi Hapus",
        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
      ),
      content: const Text("Yakin ingin menghapus data wisata ini?"),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.purple),
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: const Text("Ya, Hapus"),
          onPressed: () {
            Navigator.pop(context);
            delete();
          },
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }

  void delete() {
    setState(() {
      _isLoading = true;
    });

    WisataBloc.deleteWisata(id: widget.wisata!.id).then(
      (value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const WisataPage(),
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan hapus data gagal, silahkan coba lagi",
          ),
        );
      },
    );
  }
}
