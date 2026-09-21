/* CrowRules Universal Membership — Spectrum Awards
   Public/publishable client only. Never place service_role/secret keys here.
*/
const CROWRULES_SUPABASE_URL = "https://cevylpnoexugwgygvtgu.supabase.co";
const CROWRULES_SUPABASE_KEY = "sb_publishable_AdfM5y6RqvF3tbvEVzDZSg_JuGTQLD-";

let crowSupabase = null;

async function loadCrowRulesSupabase() {
  if (crowSupabase) return crowSupabase;
  if (!window.supabase?.createClient) throw new Error("Supabase client library is unavailable.");
  crowSupabase = window.supabase.createClient(CROWRULES_SUPABASE_URL, CROWRULES_SUPABASE_KEY, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
      storageKey: "crowrules-universal-session",
      flowType: "pkce"
    }
  });
  return crowSupabase;
}

async function getCrowRulesMember() {
  const client = await loadCrowRulesSupabase();
  const { data: { user }, error: userError } = await client.auth.getUser();
  if (userError) throw userError;
  if (!user) return { client, user: null, profile: null, membership: null };

  const [profileResult, membershipResult] = await Promise.all([
    client.from("membership_profiles").select("id,display_name,username,bio,avatar_url,points,watch_hours").eq("id", user.id).maybeSingle(),
    client.from("crplus_universal_membership")
      .select("user_id,membership_type,role,status,level,plan_key,plan_name")
      .eq("user_id", user.id).maybeSingle()
  ]);

  return {
    client, user,
    profile: profileResult.data || null,
    membership: membershipResult.data || null,
    profileError: profileResult.error || null,
    membershipError: membershipResult.error || null
  };
}

async function ensureCrowRulesMembership() {
  const client = await loadCrowRulesSupabase();
  const { data: { user } } = await client.auth.getUser();
  if (!user) throw new Error("Sign in first.");
  const { data, error } = await client.rpc("ensure_crow_membership");
  if (error) throw error;
  return data;
}

async function signInWithCrowRulesGoogle(nextUrl) {
  const client = await loadCrowRulesSupabase();
  const redirectTo = nextUrl || window.location.href;
  const { error } = await client.auth.signInWithOAuth({
    provider: "google",
    options: { redirectTo }
  });
  if (error) throw error;
}

async function signOutCrowRules() {
  const client = await loadCrowRulesSupabase();
  const { error } = await client.auth.signOut();
  if (error) throw error;
  window.location.href = "index.html";
}

window.CrowRulesMembership = {
  loadCrowRulesSupabase,
  getCrowRulesMember,
  ensureCrowRulesMembership,
  signInWithCrowRulesGoogle,
  signOutCrowRules
};