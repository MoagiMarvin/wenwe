import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<dynamic> selectedImages;
  final int maxImages;
  final Function(List<dynamic>) onImagesSelected;

  const ImagePickerWidget({
    Key? key,
    required this.selectedImages,
    required this.maxImages,
    required this.onImagesSelected,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (widget.selectedImages.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum ${widget.maxImages} images allowed')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (kIsWeb) {
          // For web, read the image as bytes
          image.readAsBytes().then((value) {
            final newImages = List<dynamic>.from(widget.selectedImages);
            newImages.add(value);
            widget.onImagesSelected(newImages);
          });
        } else {
          // For mobile, store the file path
          final newImages = List<dynamic>.from(widget.selectedImages);
          newImages.add(File(image.path));
          widget.onImagesSelected(newImages);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      final newImages = List<dynamic>.from(widget.selectedImages);
      newImages.removeAt(index);
      widget.onImagesSelected(newImages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F6CAD),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.selectedImages.length,
          itemBuilder: (context, index) {
            Widget imageWidget;
            
            if (kIsWeb) {
              // For web, display the image from bytes
              if (widget.selectedImages[index] is Uint8List) {
                imageWidget = Image.memory(
                  widget.selectedImages[index],
                  fit: BoxFit.cover,
                );
              } else {
                imageWidget = Image.network(
                  widget.selectedImages[index].toString(),
                  fit: BoxFit.cover,
                );
              }
            } else {
              // For mobile, display the image from file
              if (widget.selectedImages[index] is File) {
                imageWidget = Image.file(
                  widget.selectedImages[index],
                  fit: BoxFit.cover,
                );
              } else {
                imageWidget = Image.network(
                  widget.selectedImages[index].toString(),
                  fit: BoxFit.cover,
                );
              }
            }
            
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageWidget,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.selectedImages.length}/${widget.maxImages} images selected',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}