class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      final message = error.toString();

      // Map common error messages to user-friendly ones
      if (message.contains('Failed to create location')) {
        return 'Unable to create the location. Please check your input and try again.';
      } else if (message.contains('Failed to update location')) {
        return 'Unable to update the location. Please try again.';
      } else if (message.contains('Failed to delete location')) {
        return 'Unable to delete the location. Please try again.';
      } else if (message.contains('Failed to get locations')) {
        return 'Unable to load locations. Please check your connection.';
      } else if (message.contains('Failed to load reports')) {
        return 'Unable to load reports. Please try again.';
      } else if (message.contains('Invalid Token')) {
        return 'Your session has expired. Please log in again.';
      } else if (message.contains('TokenExpiredError')) {
        return 'Your session has expired. Please log in again.';
      } else if (message.contains('Access Denied')) {
        return 'You do not have permission to perform this action.';
      } else if (message.contains('You don\'t have access')) {
        return 'You do not have permission to perform this action.';
      } else if (message.contains('User not found')) {
        return 'No account found with this email address.';
      } else if (message.contains('Invalid password')) {
        return 'Incorrect password. Please try again.';
      } else if (message.contains('Account is disabled')) {
        return 'Your account has been disabled. Please contact support.';
      } else if (message.contains('Email not verified')) {
        return 'Please verify your email address before logging in.';
      } else if (message.contains('Too many failed attempts')) {
        return 'Too many failed login attempts. Please try again later.';
      } else if (message.contains('User Roles not found')) {
        return 'Your account has insufficient permissions. Please contact support.';
      } else {
        return 'An unexpected error occurred. Please try again.';
      }
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
