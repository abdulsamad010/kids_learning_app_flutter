import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/child/models/child_model.dart';
import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/common/widgets/avatar_selector.dart';
import 'package:kid_app/core/common/utils/validators.dart';

class EditChildScreen extends StatefulWidget {
  final ChildModel child;

  const EditChildScreen({super.key, required this.child});

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late String _selectedAvatar;
  late String _learningLevel;

  final List<String> _learningLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child.name);
    _ageController = TextEditingController(text: widget.child.age.toString());
    _selectedAvatar = widget.child.avatar;
    _learningLevel = widget.child.learningLevel[0].toUpperCase() + widget.child.learningLevel.substring(1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < 2 || age > 12) {
      return 'Age must be between 2 and 12';
    }
    return null;
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;

    final childViewModel = context.read<ChildViewModel>();
    await childViewModel.updateChild(
      widget.child.id,
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      avatar: _selectedAvatar,
      learningLevel: _learningLevel.toLowerCase(),
    );

    if (!mounted) return;

    if (childViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(childViewModel.errorMessage!)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Child profile updated')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final childViewModel = context.watch<ChildViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Child'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: validateName,
                decoration: const InputDecoration(
                  labelText: "Child's Name",
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: _validateAge,
                decoration: const InputDecoration(
                  labelText: "Child's Age",
                  prefixIcon: Icon(Icons.cake_rounded),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Choose an Avatar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              AvatarSelector(
                selectedAvatar: _selectedAvatar,
                onSelected: (avatar) {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                },
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _learningLevel,
                decoration: const InputDecoration(
                  labelText: 'Learning Level',
                  prefixIcon: Icon(Icons.school_rounded),
                ),
                items: _learningLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _learningLevel = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Update',
                isLoading: childViewModel.isLoading,
                onPressed: childViewModel.isLoading ? null : _update,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
