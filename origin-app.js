/* PROJECT ORIGIN browser client. Publishable key only; RLS protects all records. */
(() => {
  const SUPABASE_URL = 'https://cgakpcvptyhxwfujzqoe.supabase.co';
  const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_Mdh9SVACqNFMlUNOaNUHNw_24rr-_ld';
  const status = document.querySelector('#origin-status');
  const panel = document.querySelector('#origin-account-panel');
  if (!panel) return;
  if (!window.supabase) {
    if (status) { status.textContent = 'Secure account services could not load. Refresh the page or try again later.'; status.dataset.state = 'error'; }
    return;
  }
  const client = window.supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);
  const $ = (id) => document.getElementById(id);
  const say = (message, error = false) => {
    if (!status) return;
    status.textContent = message;
    status.dataset.state = error ? 'error' : 'ok';
  };
  const escapeHtml = (value) => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  let currentUser = null;
  let isAdmin = false;

  async function loadPublicFounders() {
    const target = $('origin-public-founders');
    if (!target) return;
    const { data, error } = await client.from('project_origin_founders')
      .select('display_name,founder_number,card_engraving_name').eq('publicly_listed', true)
      .order('founder_number', {ascending:true});
    if (error) { target.textContent = 'Founder recognition is temporarily unavailable.'; return; }
    target.innerHTML = data.length ? data.map(f => '<p><strong>#'+f.founder_number+'</strong> — '+escapeHtml(f.display_name)+'</p>').join('') : '<p>Public Founder recognition will appear here when approved and published.</p>';
  }

  async function load() {
    await loadPublicFounders();
    const { data: { user }, error } = await client.auth.getUser();
    if (error) throw error;
    currentUser = user;
    if (!user) {
      $('origin-signed-out').hidden = false;
      $('origin-signed-in').hidden = true;
      return;
    }
    $('origin-signed-out').hidden = true;
    $('origin-signed-in').hidden = false;
    $('origin-user-email').textContent = user.email || '';
    const [app, member, admin] = await Promise.all([
      client.from('project_origin_applications').select('id,status,submitted_at,review_note').maybeSingle(),
      client.from('project_origin_members').select('active,member_since').maybeSingle(),
      client.rpc('project_origin_is_admin')
    ]);
    if (app.error) throw app.error;
    if (member.error) throw member.error;
    if (admin.error) throw admin.error;
    isAdmin = admin.data === true;
    $('origin-application-state').textContent = app.data ? 'Application: ' + app.data.status : 'No application submitted';
    $('origin-member-state').textContent = member.data?.active ? 'Approved member since ' + new Date(member.data.member_since).toLocaleDateString() : 'Not currently an approved member';
    $('origin-apply-form').hidden = Boolean(app.data);
    $('origin-member-content').hidden = !member.data?.active;
    $('origin-admin-panel').hidden = !isAdmin;
    if (member.data?.active) await loadMemberContent();
    if (isAdmin) await loadAdmin();
  }

  async function loadMemberContent() {
    const { data, error } = await client.from('project_origin_member_content').select('id,title,body,created_at').eq('published', true).order('created_at', {ascending:false});
    if (error) throw error;
    $('origin-member-content-list').innerHTML = data.length ? data.map(item => '<article class="origin-content-card"><h3>'+escapeHtml(item.title)+'</h3><p>'+escapeHtml(item.body).replace(/\n/g,'<br>')+'</p></article>').join('') : '<p>Private member updates will appear here as they are published.</p>';
  }

  async function loadAdmin() {
    const { data, error } = await client.from('project_origin_applications').select('id,full_name,email,message,submitted_at,status').eq('status','pending').order('submitted_at');
    if (error) throw error;
    $('origin-pending-list').innerHTML = data.length ? data.map(a => '<article class="origin-admin-item" data-app="'+a.id+'"><h3>'+escapeHtml(a.full_name)+'</h3><p>'+escapeHtml(a.email)+' · '+new Date(a.submitted_at).toLocaleString()+'</p><p>'+escapeHtml(a.message)+'</p><div class="origin-admin-actions"><button type="button" data-decision="approved">APPROVE</button><button type="button" data-decision="declined">DECLINE</button></div></article>').join('') : '<p>No pending applications.</p>';
    const { data: members, error: memberError } = await client.from('project_origin_members').select('user_id,member_since,active').eq('active',true);
    if (memberError) throw memberError;
    $('origin-founder-member').innerHTML = members.map(m => '<option value="'+m.user_id+'">'+m.user_id+'</option>').join('');
    const { data: founders, error: founderError } = await client.rpc('project_origin_admin_founders');
    if (founderError) throw founderError;
    $('origin-founder-list').innerHTML = founders.length ? founders.map(f => '<p>#'+f.founder_number+' — '+escapeHtml(f.display_name)+' — 
  }

  $('origin-signup-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    const email = $('origin-auth-email').value.trim();
    const password = $('origin-auth-password').value;
    try {
      say('Creating your account…');
      const { data, error } = await client.auth.signUp({email, password, options:{emailRedirectTo:location.origin + location.pathname}});
      if (error) throw error;
      say(data.session ? 'Account created. You are signed in.' : 'Check your email to confirm your account, then sign in. If no email arrives, the site owner must finish email delivery setup.');
    } catch (e) { say(e.message || 'Could not create the account.', true); }
  });

  $('origin-login-trigger').addEventListener('click', () => {
    $('origin-signup-form').hidden = true;
    $('origin-login-form').hidden = false;
    $('origin-login-email').value = $('origin-auth-email').value;
  });
  $('origin-create-trigger').addEventListener('click', () => {
    $('origin-login-form').hidden = true;
    $('origin-signup-form').hidden = false;
    $('origin-auth-email').value = $('origin-login-email').value;
    $('origin-auth-password').value = '';
  });

  $('origin-login-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      say('Signing in…');
      const { error } = await client.auth.signInWithPassword({email:$('origin-login-email').value.trim(),password:$('origin-login-password').value});
      if (error) throw error;
      await load(); say('You are signed in.');
    } catch (e) { say(e.message || 'Could not sign in.', true); }
  });

  $('origin-logout').addEventListener('click', async () => { await client.auth.signOut(); await load(); say('Signed out.'); });
  $('origin-apply-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      const payload = {user_id:currentUser.id,full_name:$('origin-full-name').value.trim(),email:currentUser.email,message:$('origin-message').value.trim()};
      const {error} = await client.from('project_origin_applications').insert(payload);
      if (error) throw error;
      say('Application submitted successfully. It is pending owner review; submission does not grant membership.');
      await load();
    } catch (e) { say(e.code === '23505' ? 'An application already exists for this account.' : (e.message || 'Application could not be submitted.'), true); }
  });

  $('origin-pending-list').addEventListener('click', async (event) => {
    const button = event.target.closest('[data-decision]');
    if (!button) return;
    const card = button.closest('[data-app]');
    try {
      button.disabled = true;
      const {error} = await client.rpc('project_origin_review_application',{p_application_id:card.dataset.app,p_decision:button.dataset.decision,p_review_note:null});
      if (error) throw error;
      say('Application '+button.dataset.decision+'.');
      await loadAdmin();
    } catch (e) { button.disabled = false; say(e.message || 'Review failed.', true); }
  });

  $('origin-founder-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      const {error} = await client.rpc('project_origin_assign_founder',{
        p_user_id:$('origin-founder-member').value,
        p_display_name:$('origin-founder-name').value.trim(),
        p_founder_number:Number($('origin-founder-number').value),
        p_contribution_amount:Number($('origin-founder-contribution').value),
        p_card_engraving_name:$('origin-founder-engraving').value.trim(),
        p_publicly_listed:$('origin-founder-public').checked,
        p_notes:$('origin-founder-notes').value.trim() || null
      });
      if (error) throw error;
      say('Founder number assigned and recorded. It will never be auto-assigned or reused.');
      $('origin-founder-form').reset();
      await loadAdmin();
    } catch (e) { say(e.message || 'Founder assignment failed.', true); }
  });

  client.auth.onAuthStateChange(() => { load().catch(e => say(e.message || 'Could not load your account.', true)); });
  load().catch(e => say(e.message || 'PROJECT ORIGIN is temporarily unavailable. Try again later.', true));
})();
+Number(f.contribution_amount).toFixed(2)+(f.publicly_listed?' — public':' — private')+'</p>').join('') : '<p>No Founder numbers assigned. Assignments are always manual.</p>';
  }

  $('origin-signup-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    const email = $('origin-auth-email').value.trim();
    const password = $('origin-auth-password').value;
    try {
      say('Creating your account…');
      const { data, error } = await client.auth.signUp({email, password, options:{emailRedirectTo:location.origin + location.pathname}});
      if (error) throw error;
      say(data.session ? 'Account created. You are signed in.' : 'Check your email to confirm your account, then sign in. If no email arrives, the site owner must finish email delivery setup.');
    } catch (e) { say(e.message || 'Could not create the account.', true); }
  });

  $('origin-login-trigger').addEventListener('click', () => {
    $('origin-signup-form').hidden = true;
    $('origin-login-form').hidden = false;
    $('origin-login-email').value = $('origin-auth-email').value;
  });
  $('origin-login-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      say('Signing in…');
      const { error } = await client.auth.signInWithPassword({email:$('origin-login-email').value.trim(),password:$('origin-login-password').value});
      if (error) throw error;
      await load(); say('You are signed in.');
    } catch (e) { say(e.message || 'Could not sign in.', true); }
  });

  $('origin-logout').addEventListener('click', async () => { await client.auth.signOut(); await load(); say('Signed out.'); });
  $('origin-apply-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      const payload = {user_id:currentUser.id,full_name:$('origin-full-name').value.trim(),email:currentUser.email,message:$('origin-message').value.trim()};
      const {error} = await client.from('project_origin_applications').insert(payload);
      if (error) throw error;
      say('Application submitted successfully. It is pending owner review; submission does not grant membership.');
      await load();
    } catch (e) { say(e.code === '23505' ? 'An application already exists for this account.' : (e.message || 'Application could not be submitted.'), true); }
  });

  $('origin-pending-list').addEventListener('click', async (event) => {
    const button = event.target.closest('[data-decision]');
    if (!button) return;
    const card = button.closest('[data-app]');
    try {
      button.disabled = true;
      const {error} = await client.rpc('project_origin_review_application',{p_application_id:card.dataset.app,p_decision:button.dataset.decision,p_review_note:null});
      if (error) throw error;
      say('Application '+button.dataset.decision+'.');
      await loadAdmin();
    } catch (e) { button.disabled = false; say(e.message || 'Review failed.', true); }
  });

  $('origin-founder-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    try {
      const {error} = await client.rpc('project_origin_assign_founder',{
        p_user_id:$('origin-founder-member').value,
        p_display_name:$('origin-founder-name').value.trim(),
        p_founder_number:Number($('origin-founder-number').value),
        p_contribution_amount:Number($('origin-founder-contribution').value),
        p_card_engraving_name:$('origin-founder-engraving').value.trim(),
        p_publicly_listed:$('origin-founder-public').checked,
        p_notes:$('origin-founder-notes').value.trim() || null
      });
      if (error) throw error;
      say('Founder number assigned and recorded. It will never be auto-assigned or reused.');
      $('origin-founder-form').reset();
      await loadAdmin();
    } catch (e) { say(e.message || 'Founder assignment failed.', true); }
  });

  client.auth.onAuthStateChange(() => { load().catch(e => say(e.message || 'Could not load your account.', true)); });
  load().catch(e => say(e.message || 'PROJECT ORIGIN is temporarily unavailable. Try again later.', true));
})();
