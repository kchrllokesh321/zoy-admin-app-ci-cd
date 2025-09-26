// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'package:dotted_border/dotted_border.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pdfx/pdfx.dart';

class FileData {
  final String name;
  final Uint8List bytes;
  final String? path;
  final double sizeInMB;
  final String? webPath;

  FileData({required this.name, required this.bytes, this.path, required this.sizeInMB, this.webPath});
  static Future<FileData> fromFile(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final name = filePath.split(Platform.pathSeparator).last;
    final size = bytes.length / (1024 * 1024);
    return FileData(name: name, bytes: bytes, path: filePath, sizeInMB: size);
  }

  // Static factory method inside the class
  static FileData empty() {
    return FileData(name: 'empty', bytes: Uint8List(0), sizeInMB: 0.0);
  }
}

class UploadProgress {
  final double progress;
  final String status;
  final bool isComplete;
  final String? error;
  final int? bytesUploaded;
  final int? totalBytes;

  UploadProgress({
    required this.progress,
    required this.status,
    this.isComplete = false,
    this.error,
    this.bytesUploaded,
    this.totalBytes,
  });
}

class CustomFileUploadWidget extends StatefulWidget {
  final String title;
  final List<String> allowedExtensions;
  final double maxSizeInMB;
  final bool allowZipFiles;
  final Function(FileData?)? onFileSelected;
  final FileData? selectedFile;
  final Function(UploadProgress)? onUploadProgress;
  final bool showUploadProgress;
  final bool? isEditMode;
  final Function(FileData?)? onEditFileSelected;
  final bool? showInfoIcon;
  final String? infoText;
  final String? documentNumber;
  final String? documentType;
  final String? kycRole;
  final String? screenName;
  final Function(String)? onError;
  final String? errorMessage;

  const CustomFileUploadWidget({
    super.key,
    this.title = '',
    this.allowedExtensions = const [ 'jpeg', 'png', 'pdf'],
    this.maxSizeInMB = 2.0,
    this.allowZipFiles = false,
    this.onFileSelected,
    this.selectedFile,
    this.onUploadProgress,
    this.showUploadProgress = true,
    this.isEditMode = false,
    this.onEditFileSelected,
    this.showInfoIcon = false,
    this.infoText,
    this.documentNumber,
    this.documentType,
    this.kycRole,
    this.screenName,
    this.onError,
    this.errorMessage,
  });

  @override
  State<CustomFileUploadWidget> createState() => _CustomFileUploadWidgetState();
}

class _CustomFileUploadWidgetState extends State<CustomFileUploadWidget> {
  FileData? selectedFile;
  bool isUploading = false;
  DropzoneViewController? _dropzoneController;
  bool _isDropHovered = false;
  UploadProgress? _uploadProgress;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    selectedFile = widget.selectedFile;
    _errorMessage = widget.errorMessage;
  }

  @override
  void didUpdateWidget(CustomFileUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFile != oldWidget.selectedFile) {
      setState(() {
        selectedFile = widget.selectedFile;
      });
    }
    if (widget.errorMessage != oldWidget.errorMessage) {
      setState(() {
        _errorMessage = widget.errorMessage;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    if (widget.onError != null) {
      widget.onError!(message);
    }
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        isUploading = true;
      });

      if (kIsWeb) {
        await _pickFromFiles();
      } else {
        await _showFilePickerOptions();
      }
    } catch (e) {
      _showError('Error picking file: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _showFilePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).customColors.fillColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              buildSizedBoxH(20),
              Text(
                'Select File Source',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildSizedBoxH(20),
              _buildOptionTile(
                icon: Icons.photo_library,
                title: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              _buildOptionTile(
                icon: Icons.folder,
                title: 'Files',
                onTap: () {
                  Navigator.pop(context);
                  _pickFromFiles();
                },
              ),
              buildSizedBoxH(10.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              buildSizedBoxH(15),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).customColors.textdarkcolor),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        Uint8List bytes = await image.readAsBytes();
        String? path = image.path;
        String? webPath;

        if (kIsWeb) {
          webPath = 'web_${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        }

        FileData fileData = FileData(
          name: image.name,
          bytes: bytes,
          path: path,
          webPath: webPath,
          sizeInMB: bytes.length / (1024 * 1024),
        );
        await _uploadFile(fileData);
      }
    } catch (e) {
      AppToast.show(message: 'Error accessing gallery: $e', type: ToastificationType.error);
    }
  }

  Future<void> _pickFromFiles() async {
    try {
      // Build allowed extensions list based on widget settings
      List<String> allowedExtensions = List.from(widget.allowedExtensions);
      if (widget.allowZipFiles && !allowedExtensions.contains('zip')) {
        allowedExtensions.add('zip');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile platformFile = result.files.first;

        // Validate extension immediately
        String extension = platformFile.name.split('.').last.toLowerCase();
        if (!widget.allowedExtensions.contains(extension)) {
          _showError(
            "File format must be  JPEG, PNG, or PDF",
            // 'Invalid file type. Only ${widget.allowedExtensions.join(', ')} allowed'
          );
          return;
        }

        Uint8List? fileBytes = platformFile.bytes;
        if (fileBytes == null) {
          if (!kIsWeb && platformFile.path != null) {
            fileBytes = await File(platformFile.path!).readAsBytes();
          } else {
            AppToast.show(message: 'Unable to read file data', type: ToastificationType.error);
            return;
          }
        }

        FileData fileData = FileData(
          name: platformFile.name,
          bytes: fileBytes,
          path: platformFile.path,
          sizeInMB: platformFile.size / (1024 * 1024),
        );

        await _uploadFile(fileData);
      }
    } catch (e) {
      AppToast.show(message: 'Error picking file: $e', type: ToastificationType.error);
    }
  }

  Future<void> _uploadFile(FileData fileData) async {
    try {
      setState(() {
        isUploading = true;
        _uploadProgress = UploadProgress(
          progress: 0.0,
          status: 'Starting upload...',
          bytesUploaded: 0,
          totalBytes: fileData.bytes.length,
        );
      });

      // Validate file first
      String extension = fileData.name.split('.').last.toLowerCase();
      final allowedExtensions = {'pdf','jpeg', 'png'};
      if (widget.allowZipFiles) {
        allowedExtensions.add('zip');
      }

      if (!allowedExtensions.contains(extension)) {
        setState(() {
          _uploadProgress = null;
          isUploading = false;
          selectedFile = null;
          _isDropHovered = false;
        });
        _showError(
          "File format must be JPEG, PNG, or PDF",
          // 'Invalid file format. Only ${widget.allowedExtensions.join(', ')} allowed'
        );
        return;
      }

      if (fileData.sizeInMB > widget.maxSizeInMB) {
        setState(() {
          _uploadProgress = null;
          isUploading = false;
          selectedFile = null;
          _isDropHovered = false;
        });
        _showError("File size must be smaller than 2MB");
        return;
      }

      // Simulate real upload with progress updates
      await _simulateFileUpload(fileData);

      setState(() {
        selectedFile = fileData;
        _isDropHovered = false;
      });

      // Clear any previous errors
      _clearError();

      if (widget.onFileSelected != null) {
        widget.onFileSelected!(fileData);
      }

      // Clear progress after completion
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _uploadProgress = null;
            isUploading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _uploadProgress = null;
        isUploading = false;
        selectedFile = null;
        _isDropHovered = false;
      });
      AppToast.show(message: 'Error uploading file: $e', type: ToastificationType.error);
    }
  }

  Future<void> _simulateFileUpload(FileData fileData) async {
    const int chunkSize = 1024 * 10; // 10KB chunks
    final int totalBytes = fileData.bytes.length;
    int uploadedBytes = 0;

    while (uploadedBytes < totalBytes) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 50));

      uploadedBytes += chunkSize;
      if (uploadedBytes > totalBytes) {
        uploadedBytes = totalBytes;
      }

      final double progress = uploadedBytes / totalBytes;

      setState(() {
        _uploadProgress = UploadProgress(
          progress: progress,
          status: 'Uploading...',
          bytesUploaded: uploadedBytes,
          totalBytes: totalBytes,
        );
      });

      if (widget.onUploadProgress != null) {
        widget.onUploadProgress!(_uploadProgress!);
      }
    }

    setState(() {
      _uploadProgress = UploadProgress(
        progress: 1.0,
        status: 'Upload complete!',
        isComplete: true,
        bytesUploaded: totalBytes,
        totalBytes: totalBytes,
      );
    });
  }

  void _showFilePreview() {
    if (selectedFile == null) return;

    String extension = selectedFile!.name.split('.').last.toLowerCase();
    bool isImage = ['jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
    bool isPdf = extension == 'pdf';

    if (isImage) {
      _showImagePreview();
    } else if (isPdf) {
      _openPdfViewer();
    } else {
      AppToast.show(message: 'Preview not available for this file type', type: ToastificationType.error);
    }
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: BoxConstraints(maxWidth: 900, maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _dialogHeader(context),
                // Image
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        selectedFile!.bytes,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            // height: 150,
                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                                buildSizedBoxH(8),
                                Text('Unable to load image', style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dialogHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.fillColor!,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "Uploaded Document",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 20.0, tablet: 22.0, desktop: 24.0),
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "  (${selectedFile!.name})",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.0,
                          color: Theme.of(context).customColors.textdarkcolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              HoverCloseButton(size: 50.0, onTap: () => Navigator.of(context).pop()),
            ],
          ),
          buildSizedBoxH(20.0),
          Container(height: 1.0, color: Theme.of(context).customColors.lightBorderColor),
        ],
      ),
    );
  }

  // Helper to clone Uint8List for web to avoid detached ArrayBuffer errors
  Uint8List _cloneUint8List(Uint8List data) {
    return Uint8List.fromList(data);
  }

  Future<void> _openPdfViewer() async {
    if (selectedFile == null) {
      AppToast.show(message: 'Invalid or empty file selected', type: ToastificationType.warning);
      return;
    }

    try {
      final controller = PdfControllerPinch(
        document: PdfDocument.openData(kIsWeb ? _cloneUint8List(selectedFile!.bytes) : selectedFile!.bytes),
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.8),
        builder:
            (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                constraints: BoxConstraints(maxWidth: 900, maxHeight: MediaQuery.of(context).size.height * 0.85),
                decoration: BoxDecoration(
                  color: Theme.of(context).customColors.fillColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _dialogHeader(context),
                    // PDF View
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PdfViewPinch(controller: controller, scrollDirection: Axis.vertical),
                      ),
                    ),
                    buildSizedBoxH(20.0),
                  ],
                ),
              ),
            ),
      );

      // Dispose the controller after dialog is closed
      controller.dispose();
    } catch (e) {
      AppToast.show(message: 'Failed to open PDF: $e', type: ToastificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 15.0, tablet: 16.0, desktop: 16.0),
                      fontWeight: FontWeight.w400,
                      height: 1.22,
                    ),
                  ),
                  if (widget.showInfoIcon == true) ...[
                    buildSizedboxW(8.0),
                    Tooltip(
                      constraints: BoxConstraints(maxWidth: 300.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).customColors.blackColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 14.0, desktop: 14.0),
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).customColors.fillColor,
                      ),
                      message: widget.infoText ?? "",
                      child: CustomImageView(
                        imagePath: Assets.images.svgs.icons.icInfoCircle.path,
                        height: 12.0,
                        width: 12.0,
                      ),
                    ),
                  ],
                ],
              ),
              if (widget.isEditMode == true && selectedFile != null) ...[
                TextButton(
                  onPressed: () {
                    widget.onEditFileSelected?.call(selectedFile);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: Colors.transparent,
                  ),
                  child: Text(
                    Lang.of(context).lbl_edit,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                      fontWeight: FontWeight.w400,
                      height: 1.22,
                      color: Theme.of(context).customColors.greenColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          buildSizedBoxH(8.0),
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).customColors.fillColor,
          ),
          child: selectedFile != null ? _buildSelectedFileWidget() : _buildUploadWidget(),
        ),
        // Error message below the widget
        if (_errorMessage != null) ...[buildSizedBoxH(5.0), CommanErrorMessage(errorMessage: _errorMessage!)],
      ],
    );
  }

  Widget errorMessageBuilder(String errorMessage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8.0,
      children: [
        Icon(Icons.error_outline, color: Theme.of(context).customColors.darkBlueColor, size: 18.0),
        Expanded(
          child: Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
              fontWeight: FontWeight.w400,
              color: Theme.of(context).customColors.darkBlueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadWidget() {
    return SizedBox(
      child:
          kIsWeb
              ? Stack(
                children: [
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: DropzoneView(
                      onCreated: (controller) {
                        _dropzoneController = controller;
                      },
                      operation: DragOperation.copy,
                      onHover: () {
                        setState(() => _isDropHovered = true);
                      },
                      onLeave: () {
                        setState(() => _isDropHovered = false);
                      },
                      onDropFile: (file) async {
                        try {
                          final name = await _dropzoneController!.getFilename(file);
                          final bytes = await _dropzoneController!.getFileData(file);
                          final size = bytes.length / (1024 * 1024);
                          final webPath = 'web_${DateTime.now().millisecondsSinceEpoch}_$name';

                          final fileData = FileData(
                            name: name,
                            bytes: bytes,
                            path: webPath,
                            webPath: webPath,
                            sizeInMB: size,
                          );
                          await _uploadFile(fileData);
                        } catch (e) {
                          setState(() {
                            _isDropHovered = false;
                            isUploading = false;
                          });
                          AppToast.show(message: 'Error dropping file: $e', type: ToastificationType.error);
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickFile,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            _isDropHovered
                                ? Theme.of(context).customColors.primaryColor?.withValues(alpha: 0.12)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(child: _buildUploadContent()),
                    ),
                  ),
                ],
              )
              : GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors.fillColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(child: _buildUploadContent()),
                ),
              ),
    );
  }

  Widget _buildUploadContent() {
    if (isUploading && _uploadProgress != null && widget.showUploadProgress) {
      return _buildUploadProgressIndicator();
    }

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(8.0),
        borderPadding: EdgeInsets.zero,
        color: Theme.of(context).customColors.borderColor!,
        dashPattern: [5, 5],
        strokeWidth: 1.5,
      ),
      child: SizedBox(
        height: 150.0,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF5F5F5)),
              alignment: Alignment.center,
              child: CustomImageView(
                imagePath: Assets.images.svgs.icons.icDocumentUpload.path,
                height: 24.0,
                width: 24.0,
                color: Theme.of(context).customColors.blueColor,
              ),
            ),
            buildSizedBoxH(8.0),
            Text.rich(
              TextSpan(
                text: "Click to Upload ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).customColors.blueColor,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _pickFile();
                      },
                children: [
                  TextSpan(
                    text: "or drag and drop",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).customColors.blackColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            buildSizedBoxH(7.0),
            Text(
              'Max ${widget.maxSizeInMB}MB in ${_getAllowedFormatsText()} format',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).customColors.textdarkcolor,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    if (selectedFile == null) {
      return Center(
        child: CustomImageView(
          width: 32.0,
          height: 32.0,
          imagePath: Assets.images.svgs.icons.icDocumentUpload.path,
          color: Theme.of(context).customColors.blueColor,
        ),
      );
    }

    String extension = selectedFile!.name.split('.').last.toLowerCase();
    bool isImage = ['jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
    bool isPdf = extension == 'pdf';

    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child:
            selectedFile!.bytes != null
                ? Image.memory(
                  selectedFile!.bytes,
                  width: 74.0,
                  height: 52.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFileIcon(extension);
                  },
                )
                : selectedFile!.path != null
                ? Image.file(
                  File(selectedFile!.path!),
                  width: 74.0,
                  height: 52.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFileIcon(extension);
                  },
                )
                : _buildFileIcon(extension),
      );
    } else if (isPdf) {
      return _buildFileIcon('pdf');
    } else {
      return _buildFileIcon(extension);
    }
  }

  Widget _buildFileIcon(String extension) {
    IconData iconData;
    Color iconColor;

    switch (extension.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        iconData = Icons.image;
        iconColor = Colors.green;
        break;
      case 'zip':
        iconData = Icons.folder_zip;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Theme.of(context).customColors.blueColor ?? Colors.blue;
    }

    return extension.toLowerCase() == "pdf"
        ? Center(child: CustomImageView(imagePath: Assets.images.svgs.icons.icFileIcon.path, height: 40, width: 40.0))
        : Center(child: Icon(iconData, size: 40.0, color: iconColor));
  }

  Widget _buildUploadProgressIndicator() {
    final progress = _uploadProgress!;
    final isError = progress.error != null;
    final isComplete = progress.isComplete;

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.fillColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Theme.of(context).customColors.borderColor!, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // File Icon or Preview
              Container(
                // width: 74.0,
                // height: 52.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).customColors.fillColor,
                  // border: Border.all(color: Theme.of(context).customColors.borderColor!, width: 1.0),
                ),
                child: _buildFilePreview(),
              ),
              buildSizedboxW(12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedFile?.name ?? "No file selected",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).customColors.textdarkcolor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    buildSizedBoxH(4.0),
                    Text(
                      selectedFile != null ? "${selectedFile!.sizeInMB.toStringAsFixed(1)} MB" : "0.0 MB",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).customColors.blueTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          buildSizedBoxH(12.0),

          // // Status Text
          // Text(
          //   progress.status,
          //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w500,
          //     color:
          //         isError
          //             ? Colors.red[600]
          //             : isComplete
          //             ? Colors.green[600]
          //             : Theme.of(context).customColors.primaryColor,
          //   ),
          //   textAlign: TextAlign.center,
          // ),

          // Progress Bar
          if (!isError && !isComplete) ...[
            buildSizedBoxH(12.0),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFFF5F5F5),
                    value: progress.progress,
                    color: Theme.of(context).customColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                ),
                buildSizedboxW(8.0),
                Text(
                  '${(progress.progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],

          // // Error Message
          // if (isError && progress.error != null) ...[
          //   buildSizedBoxH(8.0),
          //   Container(
          //     padding: const EdgeInsets.all(12.0),
          //     decoration: BoxDecoration(
          //       color: Colors.red[50],
          //       borderRadius: BorderRadius.circular(8.0),
          //       border: Border.all(color: Colors.red[200]!, width: 1.0),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.error_outline, size: 20, color: Colors.red[600]),
          //         buildSizedboxW(12.0),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "Upload Failed",
          //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //                   fontSize: 14,
          //                   color: Colors.red[600],
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               buildSizedBoxH(2.0),
          //               Text(
          //                 selectedFile?.name ?? "Unknown file",
          //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //                   fontSize: 12,
          //                   color: Colors.red[600],
          //                   fontWeight: FontWeight.w400,
          //                 ),
          //               ),
          //               buildSizedBoxH(2.0),
          //               Text(
          //                 progress.error!,
          //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //                   fontSize: 12,
          //                   color: Colors.red[600],
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //                 maxLines: 2,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _buildSelectedFileWidget() {
    String fileExtension = _getFileExtension(selectedFile!);
    bool isImage = ['JPEG', 'PNG', 'GIF', 'BMP', 'WEBP'].contains(fileExtension);
    bool isPdf = fileExtension == 'PDF';
    bool isZip = fileExtension == 'ZIP';
    bool canPreview = isImage || isPdf || isZip;
    bool isRemoteFile = selectedFile!.path != null && selectedFile!.path!.startsWith('http');

    Widget filePreviewWidget;
    if (isImage) {
      if (selectedFile!.bytes.isNotEmpty) {
        // Local image preview
        filePreviewWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            selectedFile!.bytes,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey[400]));
            },
          ),
        );
      } else if (isRemoteFile) {
        // Remote image preview
        filePreviewWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            selectedFile!.path!,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey[400]));
            },
          ),
        );
      } else {
        filePreviewWidget = Center(child: Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey[400]));
      }
    } else if (isPdf && isRemoteFile) {
      // Remote PDF preview: show a button to open in browser
      // filePreviewWidget = Center(
      //   child: ElevatedButton.icon(
      //     onPressed: () {
      //       launchUrlString(selectedFile!.path!);
      //     },
      //     icon: Icon(Icons.picture_as_pdf, color: Theme.of(context).customColors.redColor),
      //     label: Text('View PDF'),
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Theme.of(context).customColors.fillColor,
      //       foregroundColor: Theme.of(context).customColors.redColor,
      //     ),
      //   ),
      // );
      filePreviewWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CustomImageView(imagePath: Assets.images.svgs.icons.icFileIcon.path, height: 32, width: 32)),
            buildSizedBoxH(8),
            Text(
              fileExtension,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).customColors.redColor,
              ),
            ),
          ],
        ),
      );
    } else {
      // Default: show icon
      filePreviewWidget = Center(
        child:
            fileExtension.toLowerCase() == "pdf"
                ? Center(
                  child: CustomImageView(imagePath: Assets.images.svgs.icons.icFileIcon.path, height: 32, width: 32),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getFileIcon(fileExtension),
                      size: 32,
                      color:
                          isPdf
                              ? Theme.of(context).customColors.redColor
                              : isZip
                              ? Theme.of(context).customColors.purpleColor
                              : Theme.of(context).primaryColor,
                    ),
                    buildSizedBoxH(8),
                    Text(
                      fileExtension,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isPdf
                                ? Theme.of(context).customColors.redColor
                                : isZip
                                ? Theme.of(context).customColors.purpleColor
                                : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
      );
    }

    return Column(
      children: [
        // File Information Row
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.fillColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Theme.of(context).customColors.borderColor!, width: 1.0),
          ),
          child: Row(
            children: [
              // File Icon or Preview
              Container(
                // width: 74.0,
                // height: 52.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).customColors.fillColor,
                  // border: Border.all(color: Theme.of(context).customColors.borderColor!, width: 1.0),
                ),
                child: _buildFilePreview(),
              ),
              buildSizedboxW(12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedFile?.name ?? "No file selected",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    buildSizedBoxH(4.0),
                    Text(
                      selectedFile != null ? "${selectedFile!.sizeInMB.toStringAsFixed(1)} MB" : "0.0 MB",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).customColors.blueTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canPreview)
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CustomImageView(
                        imagePath: Assets.images.svgs.icons.icEye.path,
                        height: 20.0,
                        width: 20.0,
                        color: Theme.of(context).customColors.primaryColor,
                        onTap: _showFilePreview,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CustomImageView(
                      imagePath: Assets.images.svgs.icons.icTrashOutline.path,
                      height: 20.0,
                      width: 20.0,
                      color: Theme.of(context).customColors.primaryColor,
                      onTap: () {
                        _deleteDocDialog();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    //   ],
    // );
  }

  Future<dynamic> _deleteDocDialog() {
    final businessBloc = context.read<BusinessAccountSetupBloc>();
    final String fileNameSnapshot = selectedFile?.name ?? 'this file';
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: BlocProvider.value(
            value: businessBloc,
            child: BlocConsumer<BusinessAccountSetupBloc, BusinessAccountSetupState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(24.0),
                  clipBehavior: Clip.hardEdge,
                  constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors.fillColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Remove $fileNameSnapshot",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22.0),
                      ),
                      buildSizedBoxH(10),
                      Text(
                        "Are you sure you want to remove $fileNameSnapshot?",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0),
                      ),
                      buildSizedBoxH(16),
                      Row(
                        spacing: 10.0,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).pop();
                            },
                            child: Text(
                              "No, take me back",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.0),
                            ),
                          ),
                          CustomElevatedButton(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            borderRadius: 5.0,
                            width: 120.0,
                            height: 35.0,
                            isLoading: state.isDeleteDocumentLoading,
                            onPressed: () {
                              _removeFile();
                            },
                            text: "Yes, remove",
                            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.0,
                              color: Theme.of(context).customColors.fillColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
        return Icons.folder_zip;
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileExtension(FileData fileData) {
    // Prefer extension from path if it's a URL, else from name
    if (fileData.path != null && fileData.path!.contains('.')) {
      final uri = Uri.tryParse(fileData.path!);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        final last = uri.pathSegments.last;
        if (last.contains('.')) {
          return last.split('.').last.split('?').first.toUpperCase();
        }
      }
      // fallback: extract from path string
      final pathPart = fileData.path!.split('/').last;
      if (pathPart.contains('.')) {
        return pathPart.split('.').last.split('?').first.toUpperCase();
      }
    }
    // fallback: extract from name
    if (fileData.name.contains('.')) {
      return fileData.name.split('.').last.toUpperCase();
    }
    return fileData.name.toUpperCase();
  }

  // String _formatBytes(int bytes) {
  //   if (bytes < 1024) return '$bytes B';
  //   if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  //   if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  //   return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  // }

  String _getAllowedFormatsText() {
    List<String> formats = List.from(widget.allowedExtensions);
    if (widget.allowZipFiles && !formats.contains('zip')) {
      formats.add('zip');
    }
    return formats.map((e) => e.toUpperCase()).join('/');
  }

  // Helper: extract storage key from presigned URL (or return as-is if already a key)
  String? _extractStorageKey(String? input) {
    debugPrint('input: $input');
    if (input == null || input.isEmpty) return input;

    try {
      // Handle blob URLs - extract path from blob URL
      if (input.startsWith('blob:')) {
        debugPrint('Blob URL detected, extracting path');
        // Remove blob: prefix and parse as regular URL
        final urlWithoutBlob = input.substring(5); // Remove 'blob:' prefix
        final uri = Uri.tryParse(urlWithoutBlob);
        if (uri != null) {
          String path = uri.path;
          if (path.startsWith('/')) path = path.substring(1);

          // Find uploads/ in the path and extract from there
          final uploadsIndex = path.indexOf('uploads/');
          if (uploadsIndex != -1) {
            final extractedPath = path.substring(uploadsIndex);
            debugPrint('Extracted path from blob URL: $extractedPath');
            return extractedPath;
          }
        }
        debugPrint('Could not extract path from blob URL, returning null');
        return null;
      }

      // Handle regular URLs
      final uri = Uri.tryParse(input);
      if (uri == null) return input;

      // Use only the path without query
      String path = uri.path; // e.g. /exchek-user/uploads/ekyc/...
      if (path.startsWith('/')) path = path.substring(1);

      // Prefer substring after bucket root if present
      const bucketPrefix = 'exchek-user/';
      if (path.startsWith(bucketPrefix)) {
        return path.substring(bucketPrefix.length);
      }

      // Fallback: find first occurrence of uploads/
      final uploadsIndex = path.indexOf('uploads/');
      if (uploadsIndex != -1) {
        return path.substring(uploadsIndex);
      }

      // If none matched, return original input
      return input;
    } catch (e) {
      debugPrint('Error extracting storage key: $e');
      return input;
    }
  }

  // ignore: unused_element
  void _removeFile() async {
    context.read<BusinessAccountSetupBloc>().add(
      DeleteDocument(
        documentNumber: widget.documentNumber,
        documentType: widget.documentType,
        kycRole: widget.kycRole,
        path: _extractStorageKey(selectedFile?.path),
        screenName: widget.screenName,
      ),
    );

    await Future.delayed(Duration.zero);
    setState(() {
      selectedFile = null;
      _isDropHovered = false;
      isUploading = false;
      _uploadProgress = null;
    });
    widget.onFileSelected?.call(null);
    widget.onEditFileSelected?.call(null);
    GoRouter.of(context).pop();
  }
}
