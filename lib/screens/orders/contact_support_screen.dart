import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/order.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/common/app_back_button.dart';

/// Contact support screen for order-related issues
class ContactSupportScreen extends StatefulWidget {
  final Order? order;

  const ContactSupportScreen({super.key, this.order});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Order Issue';

  final List<String> _categories = [
    'Order Issue',
    'Delivery Problem',
    'Payment Issue',
    'Product Inquiry',
    'Return/Refund',
    'Technical Support',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _subjectController.text = 'Order ${widget.order!.orderNumber}';
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Online support is temporarily unavailable. Please use the contact details below.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Contact Support',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick contact options
              _buildQuickContactSection(),
              SizedBox(height: AppSpacing.xl),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'OR',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.foregroundSecondary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              SizedBox(height: AppSpacing.xl),

              // Submit a request form
              Text(
                'Submit a Request',
                style: AppTypography.h4.copyWith(color: AppColors.foreground),
              ),
              SizedBox(height: AppSpacing.lg),

              // Category dropdown
              _buildCategoryDropdown(),
              SizedBox(height: AppSpacing.lg),

              // Subject field
              _buildTextField(
                controller: _subjectController,
                label: 'Subject',
                hint: 'Brief description of your issue',
                validator: (v) =>
                    v?.isEmpty == true ? 'Please enter a subject' : null,
              ),
              SizedBox(height: AppSpacing.lg),

              // Message field
              _buildTextField(
                controller: _messageController,
                label: 'Message',
                hint: 'Describe your issue in detail...',
                maxLines: 6,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Please enter your message';
                  if (v!.length < 20) {
                    return 'Message must be at least 20 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.lg),

              // Order reference
              if (widget.order != null) ...[
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.foregroundSecondary,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Related Order: ${widget.order!.orderNumber}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
              ],

              // Submit button
              PrimaryButton(
                text: 'Submit Request',
                onPressed: _submitRequest,
                fullWidth: true,
              ),
              SizedBox(height: AppSpacing.lg),

              // Response time note
              Center(
                child: Text(
                  'Average response time: 2-4 hours',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Contact',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickContactCard(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Available 24/7',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening live chat...')),
                  );
                },
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickContactCard(
                icon: Icons.phone_outlined,
                title: 'Call Us',
                subtitle: '1-800-LUXE',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Initiating call...')),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickContactCard(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'support@luxe.com',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email client...')),
                  );
                },
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickContactCard(
                icon: Icons.help_outline,
                title: 'FAQ',
                subtitle: 'Quick answers',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening FAQ...')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.foreground,
            fontWeight: AppTypography.semiBold,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.foreground,
            fontWeight: AppTypography.semiBold,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          cursorColor: AppColors.primary,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.foreground),
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.destructive),
            ),
            contentPadding: EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

class _QuickContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
