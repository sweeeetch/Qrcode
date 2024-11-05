import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/excel_service.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? filePath;
  final ExcelService _excelService = ExcelService();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
      await _excelService.loadFile(filePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Select Excel File'),
            ),
            const SizedBox(height: 20),
            if (filePath != null) ...[
              Text('File loaded: ${filePath!.split('/').last}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerScreen(excelService: _excelService),
                    ),
                  );
                },
                child: const Text('Start Scanning'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}