import 'package:flutter/material.dart';
import 'package:my_app/domain/usecases/user/user_result.dart';
import '../../domain/usecases/user/update_user.dart';
import '../../domain/entities/user.dart';

class AccSettingsPage extends StatefulWidget {
  final User user;
  final UpdateUser updateUser;

  const AccSettingsPage({
    super.key,
    required this.user,
    required this.updateUser
  });

  @override
  State<AccSettingsPage> createState() => _AccSettingsPageState();
}

class _AccSettingsPageState extends State<AccSettingsPage> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;
  late TextEditingController _houseController;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _cityController = TextEditingController(text: widget.user.city);
    _streetController = TextEditingController(text: widget.user.street);
    _houseController = TextEditingController(text: widget.user.house);

    void addListener(TextEditingController c) =>
        c.addListener(_recalculateHasChanges);

    addListener(_oldPasswordController);
    addListener(_newPasswordController);
    addListener(_emailController);
    addListener(_phoneController);
    addListener(_cityController);
    addListener(_streetController);
    addListener(_houseController);
  }

  void _recalculateHasChanges() {
  final u = widget.user;

  final isPasswordChange =
      _oldPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _newPasswordController.text != _oldPasswordController.text;

  final isProfileChanged =
      _emailController.text != u.email ||
      _phoneController.text != u.phone ||
      _cityController.text != u.city ||
      _streetController.text != u.street ||
      _houseController.text != u.house;

  final changed = isPasswordChange ||
      isProfileChanged;

  if (changed != _hasChanges) {
    setState(() {
      _hasChanges = changed;
    });
  }
}


  Future<void> _updateUser() async {
    UserResult result = await widget.updateUser(
      oldUser: widget.user,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      city: _cityController.text,
      street: _streetController.text,
      house: _houseController.text,
    );

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пользователь успешно зарегистрирован'),
            backgroundColor: Colors.green,
          ),
        );
      Navigator.of(context).pushNamed('/profile', arguments: result.user);
    } else {
      final message = result.errors.join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Основная информация',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Старый пароль',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Новый пароль',
                  border: OutlineInputBorder(),
                ),
                
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Адрес доставки',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Город',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Улица',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _houseController,
                decoration: const InputDecoration(
                  labelText: 'Дом',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hasChanges ? _updateUser : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Подтвердить изменения'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Отменить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
