import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/shipping_address.dart';
import '../../providers/notifiers/auth_notifier.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/common/app_back_button.dart';

/// Address management screen for managing shipping addresses
class AddressManagementScreen extends ConsumerWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);
    final addresses = addressState.addresses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(
          'Shipping Addresses',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: addressState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? _buildEmptyState(context)
          : _buildAddressList(context, ref, addresses),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context, ref),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: AppColors.primaryForeground),
        label: Text(
          'Add Address',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primaryForeground,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_outlined,
                size: 48,
                color: AppColors.foregroundSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No Addresses Yet',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Add a shipping address to make checkout faster',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(
    BuildContext context,
    WidgetRef ref,
    List<ShippingAddress> addresses,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _AddressCard(
          address: address,
          onEdit: () => _showEditAddressDialog(context, ref, address),
          onDelete: () => _confirmDelete(context, ref, address),
          onSetDefault: () {
            ref.read(addressProvider.notifier).setDefaultAddress(address.id);
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${address.name} set as default'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        onSave: (address) {
          ref.read(addressProvider.notifier).addAddress(address);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address added successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditAddressDialog(
    BuildContext context,
    WidgetRef ref,
    ShippingAddress address,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (updatedAddress) {
          ref.read(addressProvider.notifier).updateAddress(updatedAddress);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ShippingAddress address,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Address',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        content: Text(
          'Are you sure you want to delete "${address.name}"?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.foregroundSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(addressProvider.notifier).deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final ShippingAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.border,
          width: address.isDefault ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.muted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: address.isDefault
                        ? AppColors.primary
                        : AppColors.foregroundSecondary,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.foreground,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          if (address.isDefault) ...[
                            SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Default',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryForeground,
                                  fontWeight: AppTypography.semiBold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        address.street,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      Text(
                        '${address.city}, ${address.state} ${address.zipCode}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      Text(
                        address.country,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      if (address.phone != null) ...[
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: AppColors.foregroundSecondary,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              address.phone!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.foregroundSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: onSetDefault,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Set Default'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: AppColors.foregroundSecondary,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.destructive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final ShippingAddress? address;
  final Function(ShippingAddress) onSave;

  const _AddressFormSheet({this.address, required this.onSave});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _countryController;
  late TextEditingController _phoneController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _streetController = TextEditingController(
      text: widget.address?.street ?? '',
    );
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipController = TextEditingController(text: widget.address?.zipCode ?? '');
    _countryController = TextEditingController(
      text: widget.address?.country ?? 'USA',
    );
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final address = ShippingAddress(
      id: widget.address?.id ?? '',
      name: _nameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipController.text.trim(),
      country: _countryController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      isDefault: _isDefault,
    );

    widget.onSave(address);
  }

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // Title
                Text(
                  widget.address == null ? 'Add Address' : 'Edit Address',
                  style: AppTypography.h4.copyWith(color: AppColors.foreground),
                ),
                SizedBox(height: AppSpacing.lg),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Address Label',
                  hint: 'e.g., Home, Office',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: AppSpacing.md),

                // Street
                _buildTextField(
                  controller: _streetController,
                  label: 'Street Address',
                  hint: 'Enter street address',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: AppSpacing.md),

                // City & State
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: 'City',
                        hint: 'City',
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        hint: 'State',
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),

                // ZIP & Country
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _zipController,
                        label: 'ZIP Code',
                        hint: 'ZIP',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(
                        controller: _countryController,
                        label: 'Country',
                        hint: 'Country',
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),

                // Phone
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone (Optional)',
                  hint: '+1 (555) 000-0000',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: AppSpacing.md),

                // Default toggle
                CheckboxListTile(
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() => _isDefault = value ?? false);
                  },
                  title: Text(
                    'Set as default address',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
                SizedBox(height: AppSpacing.lg),

                // Save button
                PrimaryButton(
                  text: widget.address == null ? 'Add Address' : 'Save Changes',
                  onPressed: _save,
                  fullWidth: true,
                ),
                SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
        SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          cursorColor: AppColors.primary,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.foreground),
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
            ),
            filled: true,
            fillColor: AppColors.background,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ],
    );
  }
}
