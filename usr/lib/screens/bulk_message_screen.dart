import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/customer_service.dart';
import '../models/customer.dart';

class BulkMessageScreen extends StatefulWidget {
  const BulkMessageScreen({super.key});

  @override
  State<BulkMessageScreen> createState() => _BulkMessageScreenState();
}

class _BulkMessageScreenState extends State<BulkMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final CustomerService _customerService = CustomerService();
  bool _isLoading = false;

  Future<void> _sendBulkMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message first')),
      );
      return;
    }

    final customers = _customerService.customers;
    if (customers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No customers to send message to')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate sending process
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you might use an SMS gateway API.
    // For mobile, we can try to open the SMS app with multiple numbers (device dependent)
    // or just show success for this demo.
    
    // Constructing a comma separated list of numbers
    final numbers = customers.map((c) => c.phone).join(',');
    final message = Uri.encodeComponent(_messageController.text);
    
    // Attempt to launch SMS app
    final Uri smsUri = Uri.parse('sms:$numbers?body=$message');
    
    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback or just show success in demo
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Prepared message for ${customers.length} customers!')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching SMS: $e');
    }

    setState(() {
      _isLoading = false;
      _messageController.clear();
    });
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Send message to all customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Recipients: ${_customerService.customers.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _sendBulkMessage,
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.send),
              label: Text(_isLoading ? 'Sending...' : 'Send to All'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
