import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:projetflutter_nam/utilities.dart';

Future<void> notify() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'key2',
      title: '${Emojis.money_money_bag} Alleezzzz',
      body: 'Lets go',
    ),
  );
}

Future<void> creerNotificationFinEcheance(
    NotificationDateAndTime echeance) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'key3',
        title: 'Tâche XYZ',
        body: 'Votre tâche est arrivée à échéance',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done'),
      ],
      schedule: NotificationCalendar(
        year: echeance.date.year,
        month: echeance.date.month,
        day: echeance.date.day,
        hour: echeance.timeOfDay.hour,
        minute: echeance.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ));
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

/*
 * Author : Manuel
 */
