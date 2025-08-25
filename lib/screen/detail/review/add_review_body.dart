import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_review_provider.dart';
import 'package:restaurant_app/static/review_submit_state.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class AddReviewBody extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  const AddReviewBody({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<AddReviewBody> createState() => _AddReviewBodyState();
}

class _AddReviewBodyState extends State<AddReviewBody> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RestaurantReviewProvider>();
    await provider.submitReview(
      restaurantId: widget.restaurantId,
      reviewerName: _nameController.text,
      reviewText: _reviewController.text,
    );

    if (!mounted) return;

    final state = provider.resultState;
    if (state is ReviewSubmitSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Review berhasil terkirim!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(child: Image.asset('assets/rating.png', height: 100)),
                const SizedBox(height: 48),
                Text(
                  widget.restaurantName,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Berikan review Anda untuk restoran ini ya! 😊',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Review',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Review wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                Consumer<RestaurantReviewProvider>(
                  builder: (context, value, _) {
                    final isLoading =
                        value.resultState is ReviewSubmittingState;

                    final errorText =
                        value.resultState is ReviewSubmitErrorState
                        ? (value.resultState as ReviewSubmitErrorState).message
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : _submit,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            isLoading ? 'Mengirim...' : 'Kirim Review',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.orange.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            errorText,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
