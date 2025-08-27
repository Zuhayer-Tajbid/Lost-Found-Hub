import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResolveToggle extends StatefulWidget {
  final LostFound item;

  const ResolveToggle({Key? key, required this.item}) : super(key: key);

  @override
  _ResolveToggleState createState() => _ResolveToggleState();
}

class _ResolveToggleState extends State<ResolveToggle> {
  late bool isResolved;

  @override
  void initState() {
    super.initState();
    isResolved = widget.item.isResolved;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.item.id == null) return;

        final newResolvedState = !isResolved;

        setState(() {
          isResolved = newResolvedState;
        });

        try {
          await Supabase.instance.client
              .from('lost_found')
              .update({'is_resolved': newResolvedState})
              .eq('id', widget.item.id!);
        } catch (error) {
          // Revert on error
          setState(() {
            isResolved = !newResolvedState;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isResolved ? Colors.green : Colors.grey[300],
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: isResolved ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(2),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
