import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatePageWidget extends StatefulWidget {
  final VoidCallback onAddProject;

  const CreatePageWidget({super.key, required this.onAddProject});

  @override
  State<CreatePageWidget> createState() => _CreatePageWidgetState();
}

class _CreatePageWidgetState extends State<CreatePageWidget> {
  final _formKey = GlobalKey<FormState>();
  String projectName = '';
  String description = '';
  String projectType = '';
  String projectCost = '';
  String developerAssigned = '';
  String deadline = '';
  String status = 'Upcoming';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Project'),
        backgroundColor: Colors.cyan.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Project Name',
                validator: (value) => value?.isEmpty ?? true ? 'Enter project name' : null,
                onSaved: (value) => projectName = value ?? '',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Description',
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Enter description' : null,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Project Type',
                onSaved: (value) => projectType = value ?? '',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Project Cost',
                keyboardType: TextInputType.number,
                onSaved: (value) => projectCost = value ?? '',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Developer Assigned',
                onSaved: (value) => developerAssigned = value ?? '',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Deadline (e.g., MM/DD/YYYY)',
                onSaved: (value) => deadline = value ?? '',
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: status,
                items: ['Upcoming', 'In Progress', 'Completed']
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
                onChanged: (value) => setState(() => status = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 50,),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    try {
                      DocumentReference projectRef = await FirebaseFirestore.instance.collection('projects').add({
                        'projectName': projectName,
                        'description': description,
                        'projectType': projectType,
                        'projectCost': double.tryParse(projectCost) ?? 0.0,
                        'developerAssigned': developerAssigned,
                        'deadline': deadline,
                        'status': status,
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                      // Add default milestones
                      await projectRef.collection('milestones').add({
                        'name': 'UI Design',
                        'description': 'Design user interface and experience.',
                        'status': 'Upcoming',
                      });
                      await projectRef.collection('milestones').add({
                        'name': 'Development',
                        'description': 'Implement core features.',
                        'status': 'Upcoming',
                      });
                      await projectRef.collection('milestones').add({
                        'name': 'Testing',
                        'description': 'Validate and optimize.',
                        'status': 'Upcoming',
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Project added with ID: ${projectRef.id}')),
                      );
                      _formKey.currentState?.reset();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Save', style: TextStyle(fontSize: 18, fontFamily: 'Lora')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}