import 'package:flutter/material.dart';
import 'package:techassist_app/models/ticket_model.dart'; // Import your Tickets model

class TicketLists extends ChangeNotifier {
  final List<Ticket> _tickets = []; // Specify the type of elements in the list

  List<Ticket> get tickets => _tickets.toList(); // Getter to access the list of tickets

  addTicket(Ticket ticket) {
    _tickets.add(ticket); // Add a ticket to the list
    notifyListeners(); // Notify listeners that the list has been updated
  }
}
