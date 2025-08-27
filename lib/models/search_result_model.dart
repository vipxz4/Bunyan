import 'package:bonyan/models/models.dart';

// A sealed class would be even better, but this works.
// This class acts as a wrapper to hold different types of search results.
class SearchResult {
  final ProductModel? product;
  final ProfessionalModel? professional;

  SearchResult({this.product, this.professional})
      // Ensure that only one of the two can be non-null
      : assert(product != null || professional != null),
        assert(product == null || professional == null);
}
