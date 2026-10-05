# KARE Help Desk (Flutter + Supabase)

Backend is ALREADY set up in Supabase (tables, security rules, photo storage,
and a 'register' edge function). Your URL and key are already in lib/config.dart.

## Run
    flutter create .
    flutter pub get
    flutter run          # choose Chrome

Android only: in android/app/src/main/AndroidManifest.xml nothing extra is needed for the gallery picker.

## Make yourself admin
Register in the app first, then in Supabase -> SQL Editor run:
    update public.profiles set role = 'admin' where register_number = 'YOURREGNO';
Log out and log in again: an 'Admin' button appears on the home screen.

## Screens
login_screen.dart            Login / Register (register uses the 'register' edge function)
home_screen.dart             Dashboard, Report an Issue, My Complaints, Admin
report_issue_screen.dart     Category, location, problem, photo -> complaints table + storage
my_complaints_screen.dart    Student's own complaints with status
admin_dashboard_screen.dart  Counts + all complaints, tap to change status
canteen_screen.dart          Food & Canteen

## Information is now in Supabase
Fees, subjects, hostels, blocks, canteens, exams, medical, transport etc. are stored in the
tables programs / subjects / info_items. Admins can edit them inside the app:
open any info page -> pencil icon to edit, "Add" button to add, "Delete" inside the edit box.
On the Fees page the pencil edits tuition and other fees.
Subjects can be edited in Supabase -> Table Editor -> subjects.
