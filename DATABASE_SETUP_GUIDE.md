# PM-AJAY Request Management System - Database Setup Guide

## Prerequisites
- You must have a Supabase project set up
- You need access to the Supabase SQL Editor

## Step-by-Step Instructions

### Method 1: Using Supabase Dashboard (Recommended)

1. **Login to Supabase**
   - Go to https://supabase.com
   - Login to your account
   - Select your PM-AJAY project

2. **Open SQL Editor**
   - Click on "SQL Editor" in the left sidebar
   - Click "New Query" button

3. **Run the Schema Script**
   - Open the file: `supabase/request_management_schema.sql`
   - Copy ALL contents of the file
   - Paste into the SQL Editor
   - Click "Run" button (or press Ctrl+Enter / Cmd+Enter)

4. **Verify Tables Created**
   - Go to "Table Editor" in the left sidebar
   - You should see these new tables:
     - `state_requests`
     - `public_requests`
     - `agency_requests`
     - `notifications`

### Method 2: Using Supabase CLI (Alternative)

If you have Supabase CLI installed:

```bash
# Navigate to your project directory
cd c:/Users/royal/Desktop/SIH_PM_AYOG/pmajay_app

# Run the migration
supabase db push

# Or run the specific file
supabase db execute -f supabase/request_management_schema.sql
```

## What the Script Creates

### 1. Tables Created
- **state_requests**: Stores requests from State to Centre
- **public_requests**: Stores requests from citizens to State
- **agency_requests**: Stores agency registration requests
- **notifications**: Stores all system notifications

### 2. Security (Row Level Security)
The script enables RLS and creates policies for:
- Centre Admins can view all state requests
- State Officers can view their state's requests
- State Admins can view their state's agency requests
- Users can view their own notifications

### 3. Indexes
Performance indexes are created for:
- Request lookups by state
- Request filtering by status
- Notification lookups by recipient

## Verification Steps

After running the script, verify everything is set up correctly:

### 1. Check Tables
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('state_requests', 'public_requests', 'agency_requests', 'notifications');
```

You should see 4 rows returned.

### 2. Check RLS is Enabled
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('state_requests', 'public_requests', 'agency_requests', 'notifications');
```

All tables should have `rowsecurity` = true

### 3. Test Insert (Optional)
```sql
-- Test inserting a notification
INSERT INTO notifications (recipient_id, notification_type, title, message)
VALUES ('00000000-0000-0000-0000-000000000000', 'test', 'Test Notification', 'This is a test');
```

## Troubleshooting

### Issue: "relation already exists"
**Solution**: Some tables already exist. You can either:
- Drop existing tables first (careful - this deletes data!)
- Or skip the script if tables are already created

### Issue: "permission denied"
**Solution**: Make sure you're running the script as a superuser or owner of the database.

### Issue: RLS policies not working
**Solution**: 
1. Check if RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
2. Verify policies exist: Check in Supabase Dashboard → Authentication → Policies

## Important Notes

⚠️ **BEFORE PRODUCTION:**
1. Review all RLS policies to ensure they match your security requirements
2. Update the user role checks in policies to match your `user_roles` table structure
3. Consider adding additional indexes based on your query patterns
4. Set up backups for your database

✅ **After Setup:**
- The Flutter app will automatically work with these tables
- No code changes needed - repositories are already configured
- Real-time subscriptions will work automatically

## Next Steps

After running the SQL script successfully:

1. ✅ Tables are created
2. ✅ Security policies are active
3. ✅ Your Flutter app is ready to use the request management system
4. 🎉 Access the app at your local URL and test the "Requests" menu

## Support

If you encounter any issues:
- Check Supabase logs in Dashboard → Database → Logs
- Verify your Supabase connection in `lib/config/supabase_config.dart`
- Ensure your Flutter app has the correct Supabase URL and anon key