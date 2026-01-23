import 'package:flutter/material.dart';
import 'src/DatabaseHelper.dart';
import 'src/job.dart';

class EditJobScreen extends StatefulWidget {
  final Job job;
  
  const EditJobScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String selectedStatus;
  late String selectedPriority;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController = TextEditingController(text: widget.job.description);
    selectedStatus = widget.job.status;
    selectedPriority = widget.job.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Edit Job'),
      ),
      body: const Center(
        child: Text('Edit screen'),
      ),
    );
  }

  @override
  void dispose(){
    _titleController.dispose();
  _descriptionController.dispose();
  super.dispose();
  }
}