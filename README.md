# iOS-Final-Project

# Tracker App

A comprehensive iOS application for managing goals and reminders with activity suggestions.

## Features

- ✅ **Goals Management**: Create, edit, and track goals with duration and start dates
- 📅 **Reminders**: Set reminders with notifications
- 🎯 **Activity Suggestions**: Browse and add activities from an external API
- 📊 **Accessibility Tracking**: Track accessibility levels for each goal and reminder
- 💾 **Local Database**: Persistent storage using SQLite

## Dependencies

### SQLite.swift
A type-safe SQLite database wrapper for Swift.

**Version**: 0.14.1 or later  
**Repository**: https://github.com/stephencelis/SQLite.swift

### Alamofire

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd Tracker
```

### 2. Install Dependencies
Follow one of the installation methods above (SPM or CocoaPods).

### 3. Configure Storyboard IDs

Open `Main.storyboard` and set the following Storyboard IDs:

| View Controller | Storyboard ID |
|----------------|---------------|
| `ManageGoalViewController` | `manageGoal` |
| `ManageReminderViewController` | `manageReminder` |
| `ActivityViewController` | `ActivityViewController` |

**How to set Storyboard ID:**
1. Select the view controller in storyboard
2. Open Identity Inspector
3. Set "Storyboard ID" field

### 4. Configure Notification Permissions

The app requests notification permissions for reminders. This is handled automatically, but ensure you have the following in `Info.plist`:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We need notification permission to remind you about your tasks</string>
```

### 5. Build and Run

1. Select a simulator or device
2. Press **⌘R** or click the Run button
3. Grant notification permissions when prompted

## Project Structure

```
Tracker/
├── Models/
│   ├── GoalModel.swift
│   ├── ReminderModel.swift
│   └── ActivityModel.swift
│
├── Database/
│   ├── GoalsDatabase.swift
│   └── RemindersDatabase.swift
│
├── ViewControllers/
│   ├── GoalViewController.swift
│   ├── ReminderViewController.swift
│   ├── ManageGoalViewController.swift
│   ├── ManageReminderViewController.swift
│   └── ActivityViewController.swift
│
├── Views/
│   ├── GoalCell.swift
│   ├── ReminderCell.swift
│   └── ActivityCell.swift
│
├── Services/
│   └── ActivityService.swift
│
└── Main.storyboard
```

## Usage

### Creating a Goal

1. Navigate to the **Goals** tab
2. Tap the **+** button
3. Enter goal details:
   - Title
   - Accessibility level (0.0 - 1.0)
   - Start date
   - Duration
4. Tap **Save**

### Creating a Reminder

1. Navigate to the **Reminders** tab
2. Tap the **+** button
3. Enter reminder details:
   - Title
   - Accessibility level (0.0 - 1.0)
   - Reminder date and time
4. Tap **Save**

### Editing Items

Tap on any goal or reminder in the list to edit it.

### Deleting Items

Swipe left on any item and tap **Delete**.

### Using Activity Suggestions

1. Navigate to the **Activities** tab
2. Browse suggested activities from the API
3. Tap **Add** button on any activity
4. Choose to add as a **Goal** or **Reminder**

## Database Schema

### Goals Table
```sql
CREATE TABLE goals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    accessibility REAL NOT NULL,
    start_date REAL NOT NULL,
    duration REAL NOT NULL
);
```

### Reminders Table
```sql
CREATE TABLE reminders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    accessibility REAL NOT NULL,
    date REAL NOT NULL
);
```

## API Integration

The app uses the **Bored API** for activity suggestions:
- **Endpoint**: `https://www.boredapi.com/api/activity`
- **Method**: GET
- **No authentication required**

## Troubleshooting

### Issue: "Storyboard doesn't contain a view controller with identifier"
**Solution**: Ensure all Storyboard IDs are set correctly (see Setup Instructions #3)

### Issue: Notifications not appearing
**Solution**: 
1. Check notification permissions in Settings → Tracker
2. Ensure reminder date is in the future
3. Check device notification settings

### Issue: Database not persisting data
**Solution**: 
1. Clean build folder (⇧⌘K)
2. Delete app from simulator/device
3. Rebuild and run
