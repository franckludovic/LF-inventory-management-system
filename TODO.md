# TODO: Fix Theme Errors in Flutter App

## Tasks
- [ ] Edit `brand_header.dart`: Replace `AppTheme.textWhite` with `Theme.of(context).textTheme.headlineSmall?.color` for title text
- [ ] Edit `brand_header.dart`: Replace `AppTheme.textSecondary` with `Theme.of(context).hintColor` for subtitle text
- [ ] Edit `custom_text_field.dart`: Replace label `color: AppTheme.textWhite` with `color: Theme.of(context).textTheme.bodyMedium?.color`
- [ ] Edit `custom_text_field.dart`: Replace text style `color: AppTheme.textWhite` with `color: Theme.of(context).textTheme.bodyMedium?.color`
- [ ] Edit `custom_text_field.dart`: Replace `hintStyle: TextStyle(color: AppTheme.textSecondary)` with `hintStyle: TextStyle(color: Theme.of(context).hintColor)`
- [ ] Edit `custom_text_field.dart`: Replace `fillColor: AppTheme.inputBackground` with `fillColor: Theme.of(context).inputDecorationTheme.fillColor`
- [ ] Edit `custom_text_field.dart`: Replace `border`, `enabledBorder`, and `focusedBorder` with `border: InputBorder.none` to make borderless
- [ ] Edit `custom_text_field.dart`: Update suffix container `color: AppTheme.inputBackground` to `color: Theme.of(context).inputDecorationTheme.fillColor` and remove border
- [ ] Edit `custom_text_field.dart`: Update suffix icon `color: AppTheme.textSecondary` to `color: Theme.of(context).hintColor`
