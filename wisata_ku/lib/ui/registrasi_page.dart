import 'package:flutter/material.dart';
import '../bloc/registrasi_bloc.dart';
import '../widget/succes_dialog.dart';
import '../widget/warning_dialog.dart';

class UIConstants {
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Tema Ungu
  static const Color primaryColor = Color(0xFF6A1B9A); // Ungu tua
  static const Color secondaryColor = Color(0xFFBA68C8); // Ungu muda
  static const Color textColor = Colors.black87;
  static const Color lightBackground = Color(0xFFF3E5F5); // Latar ungu lembut
}

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.lightBackground,
      appBar: AppBar(
        backgroundColor: UIConstants.primaryColor,
        title: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Buat Akun Baru",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: UIConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _namaTextField(),
              const SizedBox(height: UIConstants.spacingM),
              _emailTextField(),
              const SizedBox(height: UIConstants.spacingM),
              _passwordTextField(),
              const SizedBox(height: UIConstants.spacingM),
              _passwordKonfirmasiTextField(),
              const SizedBox(height: UIConstants.spacingL),
              _buttonRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  // TextField Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: _inputDecoration("Nama", Icons.person_outline),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // TextField Email
  Widget _emailTextField() {
    return TextFormField(
      decoration: _inputDecoration("Email", Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  // TextField Password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: _inputDecoration("Password", Icons.lock_outline),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // TextField Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: _inputDecoration(
        "Konfirmasi Password",
        Icons.lock_person_outlined,
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Style input field
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: UIConstants.primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        borderSide: const BorderSide(color: UIConstants.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacingM,
        horizontal: UIConstants.spacingM,
      ),
    );
  }

  // Tombol Registrasi
  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          ),
          elevation: 5,
        ),
        onPressed: _isLoading
            ? null
            : () {
                var validate = _formKey.currentState!.validate();
                if (validate && !_isLoading) _submit();
              },
        child: AnimatedSwitcher(
          duration: UIConstants.animationDuration,
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  "Registrasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  // Proses Registrasi
  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    RegistrasiBloc.registrasi(
          nama: _namaTextboxController.text,
          email: _emailTextboxController.text,
          password: _passwordTextboxController.text,
        )
        .then(
          (value) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
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
