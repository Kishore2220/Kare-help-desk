/// Paste your own values from Supabase -> Project Settings -> API
class AppConfig {
  static const supabaseUrl = 'https://fhvqasjqvsdetykywfuj.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZodnFhc2pxdnNkZXR5a3l3ZnVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTEwMzQ3NTgsImV4cCI6MjEwNjYxMDc1OH0.R5_MHwMt3WCCni9sbxacJnqC6d259UFPnDRkD9blqsY';

  /// Students log in with a register number, but Supabase Auth needs an
  /// email, so we map the register number to a private pseudo-email.
  static const emailDomain = 'students.kare.app';
  static String emailFromRegNo(String regNo) =>
      '${regNo.trim().toLowerCase()}@$emailDomain';
}
