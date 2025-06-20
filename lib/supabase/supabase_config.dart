

String env = "dev";
String get supabaseUrl => _urlMap[env] ?? '';
String get supabaseAnonKey => _keyMap[env] ?? '';

const _urlMap = {
  'dev': 'https://alksyrnokrgxmmvjthbi.supabase.co',
  'staging': 'https://alksyrnokrgxmmvjthbi.supabase.co',
  'prod': 'https://alksyrnokrgxmmvjthbi.supabase.co',
};

const _keyMap = {
  'dev': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsa3N5cm5va3JneG1tdmp0aGJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyNzcwNTUsImV4cCI6MjA2NDg1MzA1NX0.xmWTkV6pcDMrzAzmtJ4WCDOan8mb-C5jLc1nHiDHx7g',
  'staging': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsa3N5cm5va3JneG1tdmp0aGJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyNzcwNTUsImV4cCI6MjA2NDg1MzA1NX0.xmWTkV6pcDMrzAzmtJ4WCDOan8mb-C5jLc1nHiDHx7g',
  'prod': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsa3N5cm5va3JneG1tdmp0aGJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyNzcwNTUsImV4cCI6MjA2NDg1MzA1NX0.xmWTkV6pcDMrzAzmtJ4WCDOan8mb-C5jLc1nHiDHx7g',
};
