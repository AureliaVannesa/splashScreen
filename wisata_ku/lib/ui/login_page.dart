import 'package:flutter/material.dart';
import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import 'package:wisata_ku/ui/wisata_page.dart';
import 'package:wisata_ku/ui/registrasi_page.dart';
import '../widget/warning_dialog.dart';

// --- Tema Ungu Modern ---
class UIConstants {
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Warna Utama: Ungu
  static const Color primaryColor = Color(0xFF6A1B9A); // Ungu tua
  static const Color secondaryColor = Color(0xFFBA68C8); // Ungu muda
  static const Color textColor = Colors.black87;
  static const Color lightBackground = Color(0xFFF3E5F5); // Latar ungu lembut
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingL,
          vertical: UIConstants.spacingL * 2,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: UIConstants.spacingL * 2),
              Text(
                'Selamat Datang Kembali',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: UIConstants.primaryColor,
                ),
              ),
              const SizedBox(height: UIConstants.spacingL),

              _emailTextField(),
              const SizedBox(height: UIConstants.spacingM),
              _passwordTextField(),
              const SizedBox(height: UIConstants.spacingL * 1.5),
              _buttonLogin(),
              const SizedBox(height: UIConstants.spacingM),
              _menuRegistrasi(),
              const SizedBox(height: UIConstants.spacingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Masukkan email Anda",
        fillColor: Colors.white,
        filled: true,
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: UIConstants.primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: const BorderSide(
            color: UIConstants.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: UIConstants.spacingM,
          horizontal: UIConstants.spacingM,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Minimal 6 karakter",
        fillColor: Colors.white,
        filled: true,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: UIConstants.primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: const BorderSide(
            color: UIConstants.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: UIConstants.spacingM,
          horizontal: UIConstants.spacingM,
        ),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        if (value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          ),
          elevation: 5,
          shadowColor: UIConstants.secondaryColor.withOpacity(0.4),
        ),
        onPressed: (_isLoading)
            ? null
            : () {
                var validate = _formKey.currentState!.validate();
                if (validate) {
                  _submit();
                }
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
              : Text(
                  "Login",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _submit() async {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final value = await LoginBloc.login(
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      );

      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(int.parse(value.userID.toString()));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WisataPage()),
        );
      }
    } catch (error) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WarningDialog(
            description: "Login gagal. Cek kembali email dan password Anda.",
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _menuRegistrasi() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
        child: const Text(
          "Belum punya akun? Registrasi Sekarang",
          style: TextStyle(
            color: UIConstants.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
