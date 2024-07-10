import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewerPage extends StatelessWidget {
  final String filePath;

  ImageViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: Image.file(File(filePath)),
      ),
    );
  }
}

class ExcelViewerPage extends StatelessWidget {
  final String filePath;

  ExcelViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final rows = excel.tables[excel.tables.keys.first]?.rows ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Viewer'),
      ),
      body: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(rows[index].join(', ')),
          );
        },
      ),
    );
  }
}


class PdfViewerPage extends StatelessWidget {
  final String filePath;

  PdfViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}


class FilePickerService {
  Future<String?> pickFile({required List<String> allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null;
  }
}
class PdfViewerPage1 extends StatefulWidget {
  @override
  _PdfViewerPage1State createState() => _PdfViewerPage1State();
}

class _PdfViewerPage1State extends State<PdfViewerPage1> {
  String? _filePath; // Path of the currently opened PDF file

  // List of sample PDF files bundled with the app
  final List<String> samplePdfFiles = [
    'assets/motostudent/files/1st_Team_of_Each_Country.pdf',
    'assets/motostudent/files/2024_MEF_Approved_Parts_List.xlsx',
    'assets/motostudent/files/MOTOSTUDENT_REGISTRATION_PROCESS_VIII_EDITION.pdf',
    'assets/motostudent/files/MS2425_Regulations_Rev1.pdf',
    'assets/motostudent/files/Poster_Design_Contest_Rules_VIII_Edition.pdf',
    // Add more sample PDF files here
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No PDF file selected.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _openSamplePdf(String pdfPath) {
    setState(() {
      _filePath = pdfPath; // Open the selected sample PDF
    });
  }

  void _closePdfViewer() {
    setState(() {
      _filePath = null; // Clear the file path to close the PDF viewer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          if (_filePath != null)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _closePdfViewer,
            ),
        ],
      ),
      body: Center(
        child: _filePath != null
            ? PDFView(
          filePath: _filePath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageSnap: true,
          pageFling: true,
          onError: (error) {
            print(error.toString());
          },
        )
            : samplePdfFiles.isEmpty
            ? Text(
          'No PDF files found.',
          style: TextStyle(fontSize: 20),
        )
            : ListView.builder(
          itemCount: samplePdfFiles.length,
          itemBuilder: (context, index) {
            String pdfPath = samplePdfFiles[index];
            return ListTile(
              title: Text(pdfPath.split('/').last), // Display filename
              onTap: () => _openSamplePdf(pdfPath), // Open PDF on tap
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: 'Pick PDF',
        child: Icon(Icons.folder_open),
      ),
    );
  }
}

class AragonRaceCircuitPage extends StatelessWidget {
  // Method to launch URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aragón Race Circuit'),
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aragón Race Circuit',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/motostudent/circuit/aragon_circuit_1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Circuito de Alcañiz, also known as MotorLand Aragón, is a motorsport race track located in Alcañiz, Spain. It was designed by Hermann Tilke in collaboration with the British architectural firm Foster and Partners.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),
              Text(
                'The track has hosted various major events, including MotoGP, Superbike World Championship, and World Series by Renault. It is known for its challenging layout and beautiful scenery.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  Chip(
                    avatar: Icon(Icons.design_services, color: Colors.white),
                    label: Text('Designed by Hermann Tilke / Pedro de la Rosa',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.landscape, color: Colors.white),
                    label: Text('Total surface: 1,320,000 m2',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.straighten, color: Colors.white),
                    label: Text('FIM Track length: 5,344 m',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.track_changes, color: Colors.white),
                    label: Text('FIA Track length: 5,077 m',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.timeline, color: Colors.white),
                    label: Text('Longest straight: 1,211 m',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(
                        Icons.format_align_center, color: Colors.white),
                    label: Text('Width: 15 m (straight), 12 m (rest)',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.height, color: Colors.white),
                    label: Text('50 m height difference',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.compare_arrows, color: Colors.white),
                    label: Text('Max ramp: 7.2% (descent)',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.swap_horiz, color: Colors.white),
                    label: Text('Different configurations',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.swap_calls, color: Colors.white),
                    label: Text('Can be divided into 2 circuits',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.apartment, color: Colors.white),
                    label: Text('Main Paddock: 44,000 m2',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.apartment, color: Colors.white),
                    label: Text('Secondary Paddock: 9,000 m2',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.restaurant, color: Colors.white),
                    label: Text('Restaurant Service, VIP Rooms',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.garage, color: Colors.white),
                    label: Text('Pit garages: 24 of 144 m2, 12 of 96 m2',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.local_parking, color: Colors.white),
                    label: Text('Car Parks: 950,650 m2',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.videocam, color: Colors.white),
                    label: Text(
                        'Media Centre: 270 people (main), 30 people (secondary)',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.motorcycle, color: Colors.white),
                    label: Text('Circuito motocross Motorland',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.motorcycle, color: Colors.white),
                    label: Text(
                        'Homologations: FIA (Formula 1), FIM (Top international)',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                  Chip(
                    avatar: Icon(Icons.schedule, color: Colors.white),
                    label: Text(
                        'Track schedule: 9:00h - 13:00h, 14:00h - 17:30h',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red[700],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Team Information:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              Text(
                'Here you can provide some information specific to your team, such as team members, roles, and contact information.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Race Schedule:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              Text(
                'Provide the schedule for upcoming races and practice sessions here.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Circuit Map:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              Text(
                'Include a map of the circuit with key locations marked, such as the paddock, pit garages, and viewing areas.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Weather Updates:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              Text(
                'Provide live weather updates for the circuit. This can be done using an API or a widget if available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Important Documents:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://example.com/important-documents');
                },
                child: Text(
                  'Download Important Documents',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'For more information, visit the official website:',
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.motorlandaragon.com');
                },
                child: Text(
                  'MotorLand Aragón Official Website',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






final FilePickerService filePickerService = FilePickerService();

  void _openFile(BuildContext context, String filePath, String fileType) {
    switch (fileType) {
      case 'pdf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(filePath: filePath),
          ),
        );
        break;
      case 'xlsx':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExcelViewerPage(filePath: filePath),
          ),
        );
        break;
      case 'image':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerPage(filePath: filePath),
          ),
        );
        break;
    }
  }

  Future<void> _pickFile(BuildContext context, List<String> extensions, String fileType) async {
    final filePath = await filePickerService.pickFile(allowedExtensions: extensions);
    if (filePath != null) {
      _openFile(context, filePath, fileType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _pickFile(context, ['pdf'], 'pdf'),
              child: Text('Open PDF'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickFile(context, ['xlsx', 'xls'], 'xlsx'),
              child: Text('Open Excel'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickFile(context, ['jpg', 'jpeg', 'png'], 'image'),
              child: Text('Open Image'),
            ),
          ],
        ),
      ),
    );
  }
