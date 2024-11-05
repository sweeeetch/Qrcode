import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/excel_service.dart';

class ScannerScreen extends StatefulWidget {
  final ExcelService excelService;

  const ScannerScreen({super.key, required this.excelService});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String lastScanned = '';
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !isProcessing && scanData.code != lastScanned) {
        setState(() {
          isProcessing = true;
          lastScanned = scanData.code!;
        });

        bool success = await widget.excelService.markAttendance(scanData.code!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Attendance marked!' : 'Email not found or error occurred'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Last scanned: ${lastScanned.isEmpty ? "None" : lastScanned}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}