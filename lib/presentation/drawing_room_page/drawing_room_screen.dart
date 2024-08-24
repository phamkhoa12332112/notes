import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/models/drawing_point.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen(
      {super.key, required this.drawingPoint, required this.onDeletePainting});

  final List<DrawingPoint> drawingPoint;
  final Function onDeletePainting;

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var availableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown
  ];

  var historyDrawingPoint = <DrawingPoint>[];
  var selectedColor = Colors.black;
  var selectedWith = SizesManager.r2;
  bool selectedDelete = false;

  DrawingPoint? currentDrawingPoint;

  DrawingPoint? detectTappedLine(Offset tapPosition) {
    for (var point in widget.drawingPoint) {
      for (var offset in point.offsets) {
        if ((offset - tapPosition).distance < selectedWith + 5) {
          return point;
        }
      }
    }
    return null;
  }

  void deleteLine(DrawingPoint lineToDelete) {
    setState(() {
      widget.drawingPoint.remove(lineToDelete);
      historyDrawingPoint = List.of(widget.drawingPoint);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.pop(context, widget.drawingPoint),
              child: const Icon(Icons.arrow_back)),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () {
                      widget.onDeletePainting();
                      Navigator.pop(context);
                    },
                    child: const Text(StringsManger.delete_painting))
              ],
            )
          ],
          title: SizedBox(
            height: SizesManager.h60,
            child: ListView.separated(
                separatorBuilder: (context, index) => GapsManager.w10,
                scrollDirection: Axis.horizontal,
                itemCount: availableColor.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = availableColor[index];
                        });
                      },
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                            border: selectedColor == availableColor[index]
                                ? Border.all(
                                    color: Colors.deepOrange.shade300,
                                    width: SizesManager.w5)
                                : null,
                            shape: BoxShape.circle),
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: BoxDecoration(
                            color: availableColor[index],
                            shape: BoxShape.circle),
                      ),
                    )),
          )),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (detail) {
              setState(() {
                currentDrawingPoint = DrawingPoint(
                    id: DateTime.now().microsecondsSinceEpoch,
                    offsets: [detail.localPosition],
                    width: selectedWith,
                    color: selectedColor);
                if (currentDrawingPoint == null) return;
                widget.drawingPoint.add(currentDrawingPoint!);
                historyDrawingPoint = List.of(widget.drawingPoint);
              });
            },
            onPanUpdate: (detail) {
              setState(() {
                if (currentDrawingPoint == null) return;
                currentDrawingPoint = currentDrawingPoint?.copyWith(
                    offsets: currentDrawingPoint!.offsets
                      ..add(detail.localPosition));
                widget.drawingPoint.last = currentDrawingPoint!;
                historyDrawingPoint = List.of(widget.drawingPoint);
              });
            },
            onPanEnd: (_) {
              currentDrawingPoint = null;
            },
            onTapDown: (details) {
              if (selectedDelete) {
                final tappedPoint = detectTappedLine(details.localPosition);
                if (tappedPoint != null) {
                  deleteLine(tappedPoint);
                }
              }
            },
            child: CustomPaint(
              painter: DrawingPainter(drawingPoints: widget.drawingPoint),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + SizesManager.p100,
              right: 0,
              bottom: SizesManager.p100,
              child: RotatedBox(
                quarterTurns: SizesManager.quarterTurns3,
                child: Slider(
                  min: SizesManager.r1,
                  max: SizesManager.r20,
                  value: selectedWith,
                  onChanged: (value) {
                    setState(() {
                      selectedWith = value;
                    });
                  },
                ),
              ))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: StringsManger.delete_bin,
            onPressed: () {
              setState(() {
                selectedDelete = !selectedDelete;
              });
            },
            backgroundColor: selectedDelete ? Colors.grey.shade300 : null,
            child: const Icon(Icons.delete_outline),
          ),
          GapsManager.w10,
          FloatingActionButton(
            heroTag: StringsManger.undo,
            onPressed: () {
              if (widget.drawingPoint.isNotEmpty &&
                  historyDrawingPoint.isNotEmpty) {
                setState(() {
                  widget.drawingPoint.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          GapsManager.w10,
          FloatingActionButton(
            heroTag: StringsManger.redo,
            onPressed: () {
              if (widget.drawingPoint.length < historyDrawingPoint.length) {
                final index = widget.drawingPoint.length;
                widget.drawingPoint.add(historyDrawingPoint[index]);
              }
            },
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {}
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}