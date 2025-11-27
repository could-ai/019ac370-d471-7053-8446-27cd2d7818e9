import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerService {
  // Singleton pattern to access data from anywhere
  static final CustomerService _instance = CustomerService._internal();
  factory CustomerService() => _instance;
  CustomerService._internal();

  // Using ValueNotifier so UI updates automatically when data changes
  final ValueNotifier<List<Customer>> customersNotifier = ValueNotifier<List<Customer>>([
    // Dummy data for testing
    Customer(id: '1', name: 'Rahul Kumar', phone: '9876543210', note: 'Interested in premium plan', reminderDate: DateTime.now().add(const Duration(days: 1))),
    Customer(id: '2', name: 'Priya Singh', phone: '9123456789', address: 'Delhi', note: 'Call back evening'),
  ]);

  void addCustomer(Customer customer) {
    final currentList = customersNotifier.value;
    customersNotifier.value = [...currentList, customer];
  }

  void removeCustomer(String id) {
    final currentList = customersNotifier.value;
    customersNotifier.value = currentList.where((c) => c.id != id).toList();
  }

  List<Customer> get customers => customersNotifier.value;
}
