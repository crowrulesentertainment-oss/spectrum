/* CrowRules Universal Membership compatibility layer.
   Use assets/supabase.js as the single source of truth. */
(function(){
  function api(){
    if(!window.CrowRulesMembership) throw new Error("Load assets/supabase.js before crowrules-membership.js");
    return window.CrowRulesMembership;
  }
  async function status(){
    const m=await api().getCrowRulesMember();
    return {
      ok:true,
      authenticated:!!m.user,
      user:m.user||null,
      membership:m.membership||null,
      profile:m.profile||null,
      sites:["spectrum"],
      entitlements:[]
    };
  }
  async function ensureCrow(){ return api().ensureCrowRulesMembership(); }
  async function hasAccess(siteKey,minLevel){
    const m=await api().getCrowRulesMember();
    if(!m.user||!m.membership) return false;
    const levels={crow:1,crowner:2,creator:3,founder:4};
    return Number(m.membership.level||0)>=(levels[minLevel||"crow"]||1);
  }
  window.CrowRulesUniversalMembership={status,ensureCrow,hasAccess};
})();