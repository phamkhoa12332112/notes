import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

class DialogBoxNotification extends StatefulWidget {
  DialogBoxNotification(
      {super.key,
      required this.now,
      required this.timeOrLocation,
      required this.resultLocation,
      this.onDelete,
      this.onSave,
      this.onTapTime,
      this.onTapLocation});

  late DateTime now;
  late bool timeOrLocation;
  late String resultLocation;
  final Function? onDelete;
  final Function? onTapTime;
  final Function? onTapLocation;
  final Function(DateTime, String, bool)? onSave;

  @override
  State<DialogBoxNotification> createState() => _DialogBoxNotificationState();
}

enum ChoosingLocation { home, workplace }

class _DialogBoxNotificationState extends State<DialogBoxNotification> {
  late bool choosingLocal =
      (widget.resultLocation == StringsManger.private_home) ? false : true;
  String duration = StringsManger.no_duration;
  late ChoosingLocation? _character =
      (widget.resultLocation == StringsManger.private_home)
          ? ChoosingLocation.home
          : ChoosingLocation.workplace;
  final TextEditingController locationController = TextEditingController();

  void _showDatePicker() {
    DateTime firstDate = widget.now.subtract(const Duration(seconds: 1));
    DateTime lastDate = DateTime(widget.now.year + 3);
    DateTime initialDate = widget.now;

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          DateTime updateTime = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, widget.now.hour, widget.now.minute);
          widget.now = updateTime;
        });
      }
    });
  }

  void _showTimePicker() {
    TimeOfDay initialTime =
        TimeOfDay(hour: widget.now.hour, minute: widget.now.minute);
    showTimePicker(context: context, initialTime: initialTime)
        .then((pickedTime) {
      if (pickedTime != null) {
        DateTime updateTime = DateTime(widget.now.year, widget.now.month,
            widget.now.day, pickedTime.hour, pickedTime.minute);
        setState(() {
          widget.now = updateTime;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        StringsManger.edit_notification,
        style: TextStyle(fontSize: SizesManager.s20),
      ),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: widget.timeOrLocation ? SizesManager.h200 : SizesManager.h260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.timeOrLocation = false;
                          });
                          Future.delayed(Duration.zero, () async {
                            widget.onTapTime!();
                          });
                        },
                        child: Column(
                          children: [
                            Center(
                                child: Text(StringsManger.time,
                                    style: TextStyle(
                                        color: widget.timeOrLocation
                                            ? Colors.black
                                            : Colors.blue,
                                        fontWeight: FontWeight.w500))),
                            Divider(
                              thickness: SizesManager.r2,
                              color: widget.timeOrLocation
                                  ? Colors.grey.shade300
                                  : Colors.blue,
                            )
                          ],
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.timeOrLocation = true;
                            (_character == ChoosingLocation.home)
                                ? widget.resultLocation =
                                    StringsManger.private_home
                                : widget.resultLocation =
                                    StringsManger.workplace;
                          });
                          Future.delayed(Duration.zero, () async {
                            widget.onTapLocation!();
                          });
                        },
                        child: Column(
                          children: [
                            Center(
                                child: Text(StringsManger.location,
                                    style: TextStyle(
                                        color: widget.timeOrLocation
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.w500))),
                            Divider(
                              thickness: SizesManager.r2,
                              color: widget.timeOrLocation
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            )
                          ],
                        )))
              ],
            ),
            GapsManager.h10,
            widget.timeOrLocation
                ? Column(
                    children: [
                      Row(
                        children: [
                          Radio<ChoosingLocation>(
                            value: ChoosingLocation.home,
                            groupValue: _character,
                            onChanged: (ChoosingLocation? value) {
                              setState(() {
                                _character = value;
                                choosingLocal = false;
                                widget.resultLocation =
                                    StringsManger.private_home;
                              });
                            },
                          ),
                          Text(
                            StringsManger.private_home,
                            style: TextStyle(
                                fontWeight: choosingLocal
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                fontSize: SizesManager.s15),
                          ),
                        ],
                      ),
                      GapsManager.h10,
                      Row(
                        children: [
                          Radio<ChoosingLocation>(
                            value: ChoosingLocation.workplace,
                            groupValue: _character,
                            onChanged: (ChoosingLocation? value) {
                              setState(() {
                                _character = value;
                                choosingLocal = true;
                                widget.resultLocation = StringsManger.workplace;
                              });
                            },
                          ),
                          Text(StringsManger.workplace,
                              style: TextStyle(
                                  fontWeight: choosingLocal
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: SizesManager.s15))
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${StringsManger.day} ${widget.now.day} ${StringsManger.month} ${widget.now.month}'),
                              PopupMenuButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                color: Colors.white,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text(StringsManger.today),
                                    onTap: () {
                                      setState(() {
                                        widget.now = DateTime.now();
                                      });
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text(StringsManger.tomorrow),
                                    onTap: () {
                                      setState(() {
                                        widget.now = DateTime.now()
                                            .add(const Duration(days: 1));
                                      });
                                    },
                                  ),
                                  PopupMenuItem(
                                    onTap: _showDatePicker,
                                    child:
                                        const Text(StringsManger.choosing_date),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey..shade300,
                            height: SizesManager.h1,
                          )
                        ],
                      ),
                      GapsManager.h10,
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.now.hour}:${widget.now.minute}'),
                              PopupMenuButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                color: Colors.white,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      onTap: _showTimePicker,
                                      child: const Text(
                                          StringsManger.choosing_time)),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey..shade300,
                            height: SizesManager.h1,
                          )
                        ],
                      ),
                      GapsManager.h10,
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(duration),
                              PopupMenuButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                color: Colors.white,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child:
                                        const Text(StringsManger.duration_day),
                                    onTap: () {
                                      setState(() {
                                        duration = StringsManger.duration_day;
                                      });
                                    },
                                  ),
                                  PopupMenuItem(
                                    child:
                                        const Text(StringsManger.duration_week),
                                    onTap: () {
                                      setState(() {
                                        duration = StringsManger.duration_week;
                                      });
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text(
                                        StringsManger.duration_month),
                                    onTap: () {
                                      setState(() {
                                        duration = StringsManger.duration_month;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey..shade300,
                            height: SizesManager.h1,
                          )
                        ],
                      ),
                    ],
                  ),
            GapsManager.h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () {
                      if (widget.onDelete != null) {
                        widget.onDelete!();
                      }
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white)),
                    child: const Text(
                      StringsManger.delete_bin,
                      style: TextStyle(color: Colors.blue),
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white)),
                    child: const Text(
                      StringsManger.cancel,
                      style: TextStyle(color: Colors.blue),
                    )),
                ElevatedButton(
                    onPressed: () {
                      widget.onSave!(widget.now, widget.resultLocation,
                          widget.timeOrLocation);
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      StringsManger.save_button,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}