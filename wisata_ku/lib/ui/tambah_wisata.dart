import 'package:flutter/material.dart';
import 'package:wisata_ku/bloc/wisata_bloc.dart';
import 'package:wisata_ku/model/wisata.dart';
import 'package:wisata_ku/ui/wisata_page.dart';
import 'package:wisata_ku/widget/warning_dialog.dart';

class WisataForm extends StatefulWidget {
  final Wisata? wisata;

  const WisataForm({Key? key, this.wisata}) : super(key: key);

  @override
  _WisataFormState createState() => _WisataFormState();
}

class _WisataFormState extends State<WisataForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH WISATA";
  String tombolSubmit = "SIMPAN";

  final _kodeWisataController = TextEditingController();
  final _namaWisataController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _hargaTiketController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  void _checkUpdate() {
    if (widget.wisata != null) {
      setState(() {
        judul = "UBAH WISATA";
        tombolSubmit = "UBAH";
        _kodeWisataController.text = widget.wisata!.kodeWisata ?? '';
        _namaWisataController.text = widget.wisata!.namaWisata ?? '';
        _lokasiController.text = widget.wisata!.lokasi ?? '';
        _hargaTiketController.text =
            widget.wisata!.hargaTiket?.toString() ?? '';
        _deskripsiController.text = widget.wisata!.deskripsi ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeWisataTextField(),
                _namaWisataTextField(),
                _lokasiTextField(),
                _hargaTiketTextField(),
                _deskripsiTextField(),
                const SizedBox(height: 16),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeWisataTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Wisata"),
      controller: _kodeWisataController,
      validator: (value) {
        if (value!.isEmpty) return "Kode wisata harus diisi";
        return null;
      },
    );
  }

  Widget _namaWisataTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Wisata"),
      controller: _namaWisataController,
      validator: (value) {
        if (value!.isEmpty) return "Nama wisata harus diisi";
        return null;
      },
    );
  }

  Widget _lokasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Lokasi"),
      controller: _lokasiController,
      validator: (value) {
        if (value!.isEmpty) return "Lokasi harus diisi";
        return null;
      },
    );
  }

  Widget _hargaTiketTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga Tiket"),
      keyboardType: TextInputType.number,
      controller: _hargaTiketController,
      validator: (value) {
        if (value!.isEmpty) return "Harga tiket harus diisi";
        if (int.tryParse(value) == null) return "Harus berupa angka";
        return null;
      },
    );
  }

  Widget _deskripsiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Deskripsi"),
      controller: _deskripsiController,
      maxLines: 3,
      validator: (value) {
        if (value!.isEmpty) return "Deskripsi harus diisi";
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate && !_isLoading) {
          if (widget.wisata != null) {
            _ubah();
          } else {
            _simpan();
          }
        }
      },
    );
  }

  void _simpan() {
    setState(() {
      _isLoading = true;
    });

    Wisata wisataBaru = Wisata(
      id: null,
      kodeWisata: _kodeWisataController.text,
      namaWisata: _namaWisataController.text,
      lokasi: _lokasiController.text,
      hargaTiket: int.parse(_hargaTiketController.text),
      deskripsi: _deskripsiController.text,
    );

    WisataBloc.addWisata(wisata: wisataBaru)
        .then(
          (value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WisataPage()),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              builder: (context) => const WarningDialog(
                description: "Gagal menyimpan data wisata, coba lagi.",
              ),
            );
          },
        )
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  void _ubah() {
    setState(() {
      _isLoading = true;
    });

    Wisata wisataUpdate = Wisata(
      id: widget.wisata!.id,
      kodeWisata: _kodeWisataController.text,
      namaWisata: _namaWisataController.text,
      lokasi: _lokasiController.text,
      hargaTiket: int.parse(_hargaTiketController.text),
      deskripsi: _deskripsiController.text,
    );

    WisataBloc.updateWisata(wisata: wisataUpdate)
        .then(
          (value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WisataPage()),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              builder: (context) => const WarningDialog(
                description: "Gagal mengubah data wisata, coba lagi.",
              ),
            );
          },
        )
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }
}
