import 'package:flutter/material.dart';
import 'accommodation_form.dart';
import 'dining_establishment_form.dart';

class FormFactory {
  static Widget createForm({
    required String formType,
    required Function(Map<String, dynamic>) onSubmit,
    Map<String, dynamic>? initialData,
  }) {
    switch (formType.toLowerCase()) {
      case 'accommodation':
        return AccommodationForm(onSubmit: onSubmit, initialData: initialData);
      case 'dining':
        return DiningEstablishmentForm(onSubmit: onSubmit, initialData: initialData);
      default:
        return AccommodationForm(onSubmit: onSubmit, initialData: initialData);
    }
  }
}