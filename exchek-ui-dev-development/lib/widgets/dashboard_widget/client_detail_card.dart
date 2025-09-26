import 'package:exchek/core/utils/exports.dart';

class ClientDetailCard extends StatefulWidget {
  const ClientDetailCard({
    super.key,
    required this.name,
  //  required this.status,
    required this.clientType,
    required this.email,
    required this.dateAdded,
    required this.country,
    required this.address,
    required this.addressLine1,
    required this.addressLine2,
    this.onEmailUpdate,
    this.onAddressUpdate,
    required this.isActive,
    required this.statusUpdate,
    required this.isLoadingEmailUpdate,
    required this.isLoadingAddressUpdate,

  });

  final String name;
//  final String status;
  final String clientType;
  final String email;
  final String dateAdded;
  final String country;
  final String address;
  final String addressLine1;
  final String addressLine2;
  final Future<void> Function(String)? onEmailUpdate;
  final Future<void> Function(String, String)? onAddressUpdate;
  final bool isActive;
  final ValueChanged<bool> statusUpdate;
  final bool isLoadingEmailUpdate;
  final bool isLoadingAddressUpdate;

  @override
  State<ClientDetailCard> createState() => _ClientDetailCardState();
}

class _ClientDetailCardState extends State<ClientDetailCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.customColors.fillColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.getWidgetSize(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Name, Edit Button, and Status Toggle
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      widget.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.customColors.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 24,
                          tablet: 26,
                          desktop: 28,
                        ),
                      ),
                    ),
                    buildSizedboxW(12),
                  ],
                ),
              ),
              // Status with Active/Deactive Label and Toggle
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.customColors.lightGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
               Tooltip(
                message: widget.isActive
                    ? "Click to Deactivate the client"
                    : "Click to Activate the client",
                mouseCursor: SystemMouseCursors.click,
                 child: GestureDetector(
                    onTap: () =>{
                    widget.statusUpdate(!widget.isActive),
                    } ,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? const Color(0xFF10B981)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 110,
                      height: 32,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 16),
                              Text(
                                widget.isActive ? 'Active' : 'Deactive',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: widget.isActive
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               ),
                ],
              ),
            ],
          ),
          buildSizedboxW(24),
          _buildDetailsGrid(context),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = ResponsiveHelper.isWebAndIsNotMobile(context);

    if (isWide) {
      return Column(
        children: [
          // First Row: Client Type and Email
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'Client Type',
                  widget.clientType,
                  false,isLoading:false
                ),
              ),
              buildSizedboxW(40),
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'Email',
                  widget.email,
                  true,
                  onEdit: () => _showEditDialog(context, 'Email', widget.email, onEmailUpdate: widget.onEmailUpdate,isLoadingEmailUpdate:widget.isLoadingEmailUpdate),
                  isLoading: widget.isLoadingEmailUpdate, 
                ),
              ),
            ],
          ),
          buildSizedBoxH(20),
          // Second Row: Date Added and Country
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'Date Added',
                  widget.dateAdded,
                  false,isLoading:false
                ),
              ),
              buildSizedboxW(40),
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'Country',
                  widget.country,
                  false,isLoading:false
                ),
              ),
            ],
          ),
          buildSizedBoxH(20),
          // Third Row: Address (full width)
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'Address',
                  widget.address,
                  true,
                  onEdit: () => _showAddressEditDialog(context, widget.addressLine1, widget.addressLine2,onAddressUpdate: widget.onAddressUpdate,isLoadingAddressUpdate:widget.isLoadingAddressUpdate),
                  isLoading: widget.isLoadingAddressUpdate,
                ),
              ),
              Expanded(child: Container()), // Empty space to balance
            ],
          ),
        ],
      );
    }

    // Mobile layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(context, theme, 'Client Type', widget.clientType, false,isLoading:false),
        buildSizedBoxH(16),
        _buildDetailItem(
          context,
          theme,
          'Email',
          widget.email,
          true,
          onEdit: () => _showEditDialog(context, 'Email', widget.email, onEmailUpdate: widget.onEmailUpdate, isLoadingEmailUpdate:widget.isLoadingEmailUpdate),
          isLoading: widget.isLoadingEmailUpdate, 
        ),
        buildSizedBoxH(16),
        _buildDetailItem(context, theme, 'Date Added', widget.dateAdded, false,isLoading:false),
        buildSizedBoxH(16),
        _buildDetailItem(context, theme, 'Country', widget.country, false,isLoading:false),
        buildSizedBoxH(16),
        _buildDetailItem(
          context,
          theme,
          'Address',
          widget.address,
          true,
          onEdit: () => _showAddressEditDialog(context, widget.addressLine1, widget.addressLine2, onAddressUpdate: widget.onAddressUpdate,isLoadingAddressUpdate:widget.isLoadingAddressUpdate),
          isLoading: widget.isLoadingAddressUpdate,
        ),
      ],
    );
  }

 Widget _buildDetailItem(
  BuildContext context,
  ThemeData theme,
  String label,
  String value,
  bool editable, {
  VoidCallback? onEdit,
  required bool isLoading ,     
}) {
   Logger.info("isLoading>>>> $isLoading >>>label $label>>");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: ResponsiveHelper.getFontSize(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 16,
          ),
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.outline,
        ),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (editable)
            isLoading 
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'Edit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    ],
  );
}

 void _showEditDialog(
  BuildContext context,
  String fieldName,
  String currentValue, {
  Future<void>  Function(String newValue)? onEmailUpdate,
  required bool isLoadingEmailUpdate
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final theme = Theme.of(context);
      final formKey = GlobalKey<FormState>();
      final TextEditingController controller = TextEditingController(text: currentValue);
      return StatefulBuilder(
        builder: (context, setState) {
          // Validate and update button enable state
          bool validateInput() {
            final val = controller.text.trim();
            if (val.isEmpty || val == currentValue) return false;
            if (fieldName == "Email" && ExchekValidations.validateEmail(val) != null) return false;
            return true;
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit $fieldName',
                          style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$fieldName Address',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Enter $fieldName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: fieldName == 'Email'
                          ? ExchekValidations.validateEmail
                          : null,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 32), // More space between input and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: validateInput()
                              ? () async {
                                  final newValue = controller.text.trim();
                                  if (fieldName == 'Email' && onEmailUpdate != null) {
                                    setState(() {
                                      isLoadingEmailUpdate = true;
                                    });

                                    await onEmailUpdate(newValue);  // wait for API call to finish

                                    setState(() {
                                      isLoadingEmailUpdate = false;
                                    });

                                     Navigator.of(dialogContext).pop();
                                  }
                                 
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void _showAddressEditDialog(
  BuildContext context,
  String addressLine1,
  String addressLine2, 
  {Future<void> Function(String, String)? onAddressUpdate,
  required bool isLoadingAddressUpdate,
}) {
  final theme = Theme.of(context);

  final TextEditingController addressLine1Controller = TextEditingController(text: addressLine1);
  final TextEditingController addressLine2Controller = TextEditingController(text: addressLine2);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Enable if AddressLine1 is not empty and any line changed
          bool isButtonEnabled = addressLine1Controller.text.trim().isNotEmpty &&
              (addressLine1Controller.text.trim() != addressLine1.trim() );

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Address',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  buildSizedBoxH(20),
                  // Address Line 1
                  Text(
                    'Address Line 1',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  buildSizedBoxH(8),
                  TextFormField(
                    controller: addressLine1Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter address line 1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  buildSizedBoxH(16),
                  // Address Line 2
                  Text(
                    'Address Line 2',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  buildSizedBoxH(8),
                  TextFormField(
                    controller: addressLine2Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter address line 2 (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  buildSizedBoxH(24),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B7280),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      buildSizedboxW(12),
                      ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () async{
                                final newAddressLine1 = addressLine1Controller.text.trim();
                                final newAddressLine2 = addressLine2Controller.text.trim();
                                Logger.info("onAd  $newAddressLine1 >dress <><$newAddressLine2 <>Update $onAddressUpdate");
                                if (onAddressUpdate != null) {
                                   setState(() {
                                      isLoadingAddressUpdate = true;
                                    });
                                 await onAddressUpdate(newAddressLine1, newAddressLine2);
                                   setState(() {
                                      isLoadingAddressUpdate = true;
                                    });
                                }
                                Navigator.of(dialogContext).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}
  