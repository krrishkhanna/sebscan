import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FoodFactsService {
  Future<Map<String, String>?> lookupBarcode(String barcode) async {
    try {
      final uri = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] != 1) return null;
      final product = json['product'] as Map<String, dynamic>? ?? const {};
      return {
        'name': product['product_name'] as String? ?? 'Unknown product',
        'brand': product['brands'] as String? ?? 'Unknown brand',
        'ingredients': product['ingredients_text'] as String? ?? '',
      };
    } catch (error, stackTrace) {
      debugPrint('lookupBarcode failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<Map<String, String>?> searchByName(String query) async {
    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeQueryComponent(query)}&json=1&page_size=1',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final products = json['products'] as List? ?? const [];
      if (products.isEmpty) return null;
      final first = products.first as Map<String, dynamic>;
      return {
        'name': first['product_name'] as String? ?? query,
        'brand': first['brands'] as String? ?? 'Unknown brand',
        'ingredients': first['ingredients_text'] as String? ?? '',
      };
    } catch (error, stackTrace) {
      debugPrint('searchByName failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }
}
