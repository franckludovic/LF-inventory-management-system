class AppStrings {
  // App Title
  static const String appTitle = 'LFS';
  static const String appSubTitle = 'Inventory Management System';


  // Login Screen
  static const String username = 'Username';
  static const String password = 'Password';
  static const String enterYourIdOrEmail = 'Enter your ID or email';
  static const String enterYourPassword = 'Enter your password';
  static const String login = 'Login';
  static const String validationError = 'Please enter username and password';


  // Dashboard Screen
  static const String dashboard = 'Dashboard';
  static const String welcomeBack = 'Welcome Back';
  static const String quickActions = 'Quick Actions';
  static const String searchParts = 'Search Parts';
  static const String viewInventory = 'View Inventory';
  static const String checkReports = 'Check Reports';
  static const String stockAlerts = 'Stock Alerts';
  static const String lowStockItems = 'Low Stock Items';
  static const String outOfStock = 'Out of Stock';
  static const String qty = 'Qty:';
  static const String location = 'Loc:';

  // Search Screen
  static const String searchSpareParts = 'Search Spare Parts';
  static const String searchByPartNameOrSku = 'Search by part name or SKU...';
  static const String inStock = 'In Stock';
  static const String otis = 'Otis';
  static const String schindler = 'Schindler';
  static const String showingResults = 'Showing 24 Results';

  // Navigation
  static const String home = 'Home';
  static const String inventory = 'Inventory';
  static const String reports = 'Reports';
  static const String profile = 'Profile';

  // Part Details
  static const String partDetails = 'Part Details';
  static const String share = 'Share';
  static const String hydraulicValveBlockX2 = 'Hydraulic Valve Block - X2';
  static const String ref9920Bt = 'REF-9920-BT';
  static const String schindlerOem = 'Schindler / OEM';
  static const String totalStock = 'Total Stock';
  static const String units = 'Units';
  static const String locationBreakdown = 'Location Breakdown';
  static const String sac1 = 'Sac 1';
  static const String sac3 = 'Sac 3';
  static const String vanStock = 'Van Stock';
  static const String lastUpdated = 'Last updated: Today, 08:42 AM by Technician ID: 4492';
  static const String updateStock = 'Update Stock';
  static const String addReplaceImage = 'Add / Replace Image';

  // Part names
  static const String overspeedGovernor = 'Overspeed Governor';
  static const String doorRollerAssembly = 'Door Roller Assembly';
  static const String emergencyLightBattery = 'Emergency Light Battery';
  static const String mainControlPcb = 'Main Control PCB';
  static const String tractionRope12mm = 'Traction Rope 12mm';

  // Brands
  static const String kone = 'Kone';
  static const String genericOem = 'Generic / OEM';
  static const String thyssenKrupp = 'ThyssenKrupp';

  // Locations
  static const String sac3Sac6 = 'Sac 3, Sac 6';
  static const String sac1Bin12a = 'Sac 1, Bin 12A';
  static const String serviceTruckA = 'Service Truck A';
  static const String sac9HqDepot = 'Sac 9, HQ Depot';
  static const String externalWarehouse = 'External Warehouse';

  // Quantities
  static const String qty03 = '03';
  static const String qty12 = '12';
  static const String qty01 = '01';
  static const String qty02 = '02';
  static const String qty50m = '50m';

  // Stock Update Screen
  static const String selectPart = 'Select Part';
  static const String searchElevatorPart = 'Search elevator part...';
  static const String currentStock = 'Current Stock:';
  static const String storageBag = 'Storage Bag';
  static const String sac1MainInventory = 'Sac 1 - Main Inventory';
  static const String sac2ServiceVan = 'Sac 2 - Service Van';
  static const String sac3EmergencyKit = 'Sac 3 - Emergency Kit';
  static const String quantity = 'Quantity';
  static const String addStock = 'Add Stock';
  static const String removeStock = 'Remove Stock';
  static const String optionalNote = 'Optional Note';
  static const String noteHint = 'E.g. Damaged unit return, site transfer...';
  static const String confirmChange = 'Confirm Change';

  // Stock Update Success Screen
  static const String stockUpdateSuccess = 'Stock Update Successful';
  static const String stockUpdatedMessage = 'Your stock has been updated successfully.';
  static const String backToInventory = 'Back to Inventory';

  // Stock Update Error Modal
  static const String stockUpdateError = 'Stock Update Error';
  static const String exceedsMaxCapacity = 'The quantity you are trying to add exceeds the maximum capacity of the selected location.';
  static const String maxAllowedToAdd = 'Maximum allowed to add:';
  static const String unitsLower = 'units';
  static const String adjustQuantity = 'Adjust Quantity';
  static const String chooseAnotherLocation = 'Choose Another Location';

  // Generate Report Screen
  static const String generateReport = 'Generate Report';
  static const String reportType = 'Report Type';
  static const String weeklyStockActivityReport = 'Weekly Stock Activity Report';
  static const String monthlySummary = 'Monthly Summary';
  static const String technicianUsageReport = 'Technician Usage Report';
  static const String lowStockAlerts = 'Low Stock Alerts';
  static const String dateRange = 'Date Range';
  static const String startDate = 'Start Date';
  static const String endDate = 'End Date';
  static const String filtersOptional = 'Filters (Optional)';
  static const String partName = 'Part Name';
  static const String technicianName = 'Technician Name';
  static const String generateReportButton = 'Generate Report';
  static const String reportDescription = 'A summary of all elevator spare parts movement for the selected period.';

  // Report Details Screen
  static const String reportPeriod = 'Report Period';
  static const String totalAdditions = 'Total Additions';
  static const String totalRemovals = 'Total Removals';
  static const String activityDetails = 'Activity Details';
  static const String detailedBreakdown = 'Detailed breakdown of all stock movements';
  static const String date = 'Date';
  static const String part = 'Part';
  static const String type = 'Type';
  static const String qtyShort = 'Qty';
  static const String by = 'By';
  static const String added = 'Added';
  static const String removed = 'Rem.';
  static const String showingTransactions = 'Showing 5 of 57 transactions';
  static const String exportPDF = 'Export PDF';
  static const String exportCSV = 'Export CSV';
  static const String backToDashboard = 'Back to Dashboard';

  // Parts Management Screen
  static const String partsManagement = 'Parts Management';

  // Add Part Screen
  static const String addNewSparePart = 'Add New Spare Part';
  static const String partNameLabel = 'Part Name';
  static const String partNameHint = 'e.g. Elevator Door Roller';
  static const String designationReference = 'Designation / Reference';
  static const String designationHint = 'e.g. REF-2024-X1';
  static const String manufacturer = 'Manufacturer';
  static const String manufacturerHint = 'e.g. Manufacturer Name';
  static const String descriptionOptional = 'Description (Optional)';
  static const String descriptionHint = 'Add specific details or usage notes...';
  static const String initialQuantity = 'Initial Quantity';
  static const String bagLocation = 'Bag Location';
  static const String selectLocation = 'Select Location';
  static const String mainWarehouseA1 = 'Main Warehouse - A1';
  static const String serviceVanV04 = 'Service Van - V04';
  static const String regionalHubWest = 'Regional Hub - West';
  static const String partPhoto = 'Part Photo';
  static const String captureOrUploadImage = 'Capture or Upload Image';
  static const String maxSize5MB = 'Max size: 5MB';
  static const String upload = 'Upload';
  static const String camera = 'Camera';
  static const String savePart = 'Save Part';

  // User Management Screen
  static const String userManagement = 'User Management';
  static const String searchTechnicians = 'Search technicians...';
  static const String activeTechnicians = 'Active Technicians';
  static const String blockedTechnicians = 'Blocked Technicians';
  static const String block = 'Block';
  static const String unblock = 'Unblock';
  static const String addNewTechnician = 'Add New Technician';
  static const String seniorTechnician = 'Senior Technician';
  static const String technician = 'Technician';
  static const String maintenanceSpecialist = 'Maintenance Specialist';
  static const String active = 'Active';
  static const String blocked = 'Blocked';

  // Add User Screen
  static const String addTechnician = 'Add Technician';
  static const String fullName = 'Full Name';
  static const String enterTechniciansFullName = 'Enter technician\'s full name';
  static const String usernameLabel = 'Username';
  static const String enterUsername = 'e.g. jdoe_tech';
  static const String temporaryPassword = 'Temporary Password';
  static const String setTemporaryPassword = 'Set temporary password';
  static const String passwordHint = 'The user will be prompted to change this on first login.';
  static const String role = 'Role';
  static const String technicianRole = 'Technician';
  static const String saveTechnician = 'Save Technician';
  static const String cancel = 'Cancel';

  // Location Management
  static const String locationManagement = 'Location Management';
  static const String searchLocations = 'Search locations...';
  static const String noLocationsFound = 'No locations found';
  static const String addNewLocation = 'Add New Location';
  static const String editLocation = 'Edit Location';
  static const String locationName = 'Location Name';
  static const String enterLocationName = 'Enter location name';
  static const String maxLocationQuantity = 'Max Location Quantity';
  static const String enterMaxQuantity = 'Enter max quantity';
  static const String saveLocation = 'Save Location';
}
