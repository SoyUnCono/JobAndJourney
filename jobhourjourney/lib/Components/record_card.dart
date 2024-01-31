import 'package:flutter/material.dart';
import 'package:jobhourjourney/Models/Day_record.dart';

Card recordCard(
    BuildContext context, DayRecord record, int index, Function(int) onDelete) {
  return Card(
    elevation: 5.0,
    shadowColor: Theme.of(context).colorScheme.primary,
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(10),
      title: Text(
        record.job,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${record.date} - ${record.hours}h - a ${record.salary}\$',
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              if (record.hasOvertime)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text(' / '),
                    Text(
                      '${record.overtimeRate}\$ - ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${record.overtimeHours}h ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                )
            ],
          )
        ],
      ),
      dense: true,
      isThreeLine: true,
      trailing: SizedBox(
        width: 42,
        height: 42,
        child: IconButton(
          icon: Image.asset('./images/trash.png', color: Colors.red,),
          hoverColor: Colors.redAccent,
          onPressed: () {onDelete(index);},
        ),
      ),
    ),
  );
}
