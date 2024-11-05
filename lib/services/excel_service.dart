import 'package:excel/excel.dart';
import 'dart:io';

class ExcelService {
  Excel? _excel;
  String? _filePath;
  final String _sheetName = 'Sheet1';
  final int _emailColumn = 0;
  final int _presenceColumn = 1;

  Future<void> loadFile(String filePath) async {
    _filePath = filePath;
    var bytes = File(filePath).readAsBytesSync();
    _excel = Excel.decodeBytes(bytes);
  }

  Future<bool> markAttendance(String email) async {
    if (_excel == null || _filePath == null) return false;

    var sheet = _excel![_sheetName];
    bool found = false;
    int? rowIndex;

    for (var row = 0; row < sheet.maxRows; row++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: _emailColumn,
        rowIndex: row,
      ));

      if (cell.value?.toString().toLowerCase() == email.toLowerCase()) {
        found = true;
        rowIndex = row;
        break;
      }
    }

    if (found && rowIndex != null) {
      var presenceCell = sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: _presenceColumn,
        rowIndex: rowIndex,
      ));

      int currentPresence = int.tryParse(presenceCell.value?.toString() ?? '0') ?? 0;
      presenceCell.value = currentPresence + 1;

      var fileBytes = _excel!.encode();
      if (fileBytes != null) {
        File(_filePath!).writeAsBytesSync(fileBytes);
        return true;
      }
    }

    return false;
  }
}