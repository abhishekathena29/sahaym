import 'package:bridging_saathi/logic/model/patient/patient.dart';
import 'package:bridging_saathi/screens/login/cubit/profile/profile_cubit.dart';
import 'package:bridging_saathi/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/login/cubit/patient/patient_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> educationLevels = [
    '10th',
    '12th',
    'Graduate',
    'Post Graduate',
    'Doctorate',
    'Other',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _spouseAgeController = TextEditingController();

  String? _gender;
  String? _educationLevel;
  bool _hasBp = false;
  bool _hasDiabetes = false;
  bool _hasKneeProblems = false;
  bool _hasSleepIssues = false;
  bool _hasMemoryIssues = false;
  bool _hasWeakness = false;
  bool _hadSurgery = false;

  Patient? patient;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfilePatientLoaded) {
      patient = state.patient;
      _nameController.text = patient?.fullName ?? '';
      _phoneController.text = patient?.phoneNumber ?? '';
      _ageController.text = patient?.age?.toString() ?? '';
      _spouseAgeController.text = patient?.spouseAge?.toString() ?? '';
      _gender = patient?.gender ?? '';
      _educationLevel = patient?.educationLevel ?? '';
      _hasBp = patient?.hasBp ?? false;
      _hasDiabetes = patient?.hasDiabetes ?? false;
      _hasKneeProblems = patient?.hasKneeProblems ?? false;
      _hasSleepIssues = patient?.hasSleepIssues ?? false;
      _hasMemoryIssues = patient?.hasMemoryIssues ?? false;
      _hasWeakness = patient?.hasWeakness ?? false;
      _hadSurgery = patient?.hadSurgery ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _spouseAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PatientCubit, PatientState>(
        listener: (context, state) {
          if (state is PatientAddLoading || state is PatientUpdateLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.of(context, rootNavigator: true)
                .popUntil((route) => route.isFirst);
            if (state is PatientAddSuccess || state is PatientUpdateSuccess) {
              context.read<ProfileCubit>().getUser();
              showSnackBar(
                  context,
                  patient != null
                      ? 'Profile updated successfully!'
                      : 'Form submitted successfully!',
                  true);
              context.go('/mainScreen');
              context.go('/mainScreen');
            } else if (state is PatientAddError ||
                state is PatientUpdateError) {
              final message = state is PatientAddError
                  ? state.message
                  : (state as PatientUpdateError).message;
              showSnackBar(context, message, false);
              showSnackBar(context, message, false);
            }
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                title: const Text('Personal / Health Details'),
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Personal Details'),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().isEmpty) {
                          return 'Name cannot be just whitespace';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      readOnly: true,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your phone number'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        final age = int.tryParse(value);
                        if (age == null) {
                          return 'Please enter a valid number';
                        }
                        if (age < 1 || age > 120) {
                          return 'Please enter a valid age (1-120)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _spouseAgeController,
                      decoration: InputDecoration(
                        labelText: 'Spouse Age',
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    _buildSectionTitle('Gender'),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Radio<String>(
                          value: 'male',
                          groupValue: _gender,
                          onChanged: (value) => setState(() => _gender = value),
                        ),
                        const Text('Male'),
                        Radio<String>(
                          value: 'female',
                          groupValue: _gender,
                          onChanged: (value) => setState(() => _gender = value),
                        ),
                        const Text('Female'),
                        Radio<String>(
                          value: 'other',
                          groupValue: _gender,
                          onChanged: (value) => setState(() => _gender = value),
                        ),
                        const Text('Other'),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildSectionTitle('Education'),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      value: _educationLevel,
                      hint: const Text('Select Education Level'),
                      items: educationLevels.map((String level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _educationLevel = value),
                      validator: (value) => value == null
                          ? 'Please select education level'
                          : null,
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionTitle('Health Problems'),
                    _buildCheckboxTile('Blood Pressure (BP)', _hasBp,
                        (value) => setState(() => _hasBp = value ?? false)),
                    _buildCheckboxTile(
                        'Diabetes',
                        _hasDiabetes,
                        (value) =>
                            setState(() => _hasDiabetes = value ?? false)),
                    _buildCheckboxTile(
                        'Knee Problems',
                        _hasKneeProblems,
                        (value) =>
                            setState(() => _hasKneeProblems = value ?? false)),
                    _buildCheckboxTile(
                        'Sleep Issues',
                        _hasSleepIssues,
                        (value) =>
                            setState(() => _hasSleepIssues = value ?? false)),
                    _buildCheckboxTile(
                        'Memory Issues',
                        _hasMemoryIssues,
                        (value) =>
                            setState(() => _hasMemoryIssues = value ?? false)),
                    _buildCheckboxTile(
                        'Weakness',
                        _hasWeakness,
                        (value) =>
                            setState(() => _hasWeakness = value ?? false)),
                    SizedBox(height: 24.h),
                    _buildSectionTitle('Surgery History'),
                    _buildCheckboxTile(
                        'Had Surgery',
                        _hadSurgery,
                        (value) =>
                            setState(() => _hadSurgery = value ?? false)),
                    SizedBox(height: 24.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 48.w, vertical: 10.h),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'Update',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    void Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _submitForm() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      showSnackBar(context, 'Please fill all required fields correctly', false);
      return;
    }

    // Check if gender is selected
    if (_gender == null || _gender!.isEmpty) {
      showSnackBar(context, 'Please select your gender', false);
      return;
    }

    // Check if education level is selected
    if (_educationLevel == null || _educationLevel!.isEmpty) {
      showSnackBar(context, 'Please select your education level', false);
      return;
    }

    // Proceed with form submission
    if (patient != null) {
      context.read<PatientCubit>().updatePatient(
            id: patient!.id!,
            fullName: _nameController.text,
            phoneNumber: _phoneController.text,
            age: int.tryParse(_ageController.text) ?? 0,
            spouseAge: int.tryParse(_spouseAgeController.text) ?? 0,
            gender: _gender ?? '',
            educationLevel: _educationLevel ?? '',
            hasBp: _hasBp,
            hasDiabetes: _hasDiabetes,
            hasKneeProblems: _hasKneeProblems,
            hasSleepIssues: _hasSleepIssues,
            hasMemoryIssues: _hasMemoryIssues,
            hasWeakness: _hasWeakness,
            hadSurgery: _hadSurgery,
          );
    } else {
      context.read<PatientCubit>().addPatient(
            fullName: _nameController.text,
            phoneNumber: _phoneController.text,
            age: int.tryParse(_ageController.text) ?? 0,
            spouseAge: int.tryParse(_spouseAgeController.text) ?? 0,
            gender: _gender ?? '',
            educationLevel: _educationLevel ?? '',
            hasBp: _hasBp,
            hasDiabetes: _hasDiabetes,
            hasKneeProblems: _hasKneeProblems,
            hasSleepIssues: _hasSleepIssues,
            hasMemoryIssues: _hasMemoryIssues,
            hasWeakness: _hasWeakness,
            hadSurgery: _hadSurgery,
          );
    }
  }
}
