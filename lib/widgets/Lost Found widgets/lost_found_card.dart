import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundCard extends StatelessWidget {
  const LostFoundCard({super.key, required this.item, this.imageUrl});

  final LostFound item;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 60),
      child: Opacity(
        opacity: item.isResolved ? 0.4 : 1.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: item.isResolved
              ? const Color.fromARGB(255, 127, 108, 108)
              : item.isLost
              ? Colors.red.shade200
              : Colors.amber.shade300,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Container(
                      width: 180,
                      height: 250,
                      color: Colors.white54,
                      child: item.photoUrl == null
                          ? Icon(
                              item.isLost
                                  ? Icons.search_off
                                  : Icons.check_circle_outline,
                              color: Colors.black,
                              size: 70,
                            )
                          : Image.network(imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            item.title,
                            style: TextStyle(
                              fontFamily: 'font',
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            softWrap: true,
                            maxLines: 2, // Optional: limit to 3 lines
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontFamily: 'font',
                              fontSize: 19,
                              color: Colors.black87,
                            ),
                            maxLines: 4, // Show maximum 3 lines
                            overflow: TextOverflow
                                .ellipsis, // This adds the ... at the end
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 5,
                left: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: item.isLost
                        ? Colors.red.shade200
                        : Colors.amber.shade300,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          item.isLost
                              ? Icons.search_off
                              : Icons.check_circle_outline,
                          color: Colors.black,
                        ),
                        SizedBox(width: 3),
                        Text(
                          item.isLost ? 'Lost' : 'Found',
                          style: TextStyle(
                            fontFamily: 'font',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 7,
                child: !item.isResolved
                    ? SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.shade400,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(Icons.done, color: Colors.black),
                              SizedBox(width: 3),
                              Text(
                                'Resolved',
                                style: TextStyle(
                                  fontFamily: 'font',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Positioned(
                bottom: 5,
                right: 15,
                child: Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(item.dateTime),
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'font',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
