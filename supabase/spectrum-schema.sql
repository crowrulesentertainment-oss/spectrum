-- Spectrum Awards foundation for the CrowRules universal ecosystem.
-- Review this migration against existing Spectrum tables before running.
-- Public clients use the publishable/anon key only. Never expose service_role in GitHub Pages.

create table if not exists public.spectrum_categories (
 id uuid primary key default gen_random_uuid(), name text not null, description text,
 sort_order int default 0, active boolean default true, created_at timestamptz default now()
);
create table if not exists public.spectrum_nominations (
 id uuid primary key default gen_random_uuid(), category_id uuid references public.spectrum_categories(id) on delete set null,
 nominee_name text not null, work_title text, nominee_type text, description text,
 submitted_by uuid references auth.users(id) on delete set null,
 status text not null default 'submitted' check(status in ('submitted','under_review','approved','finalist','winner','rejected')),
 voting_round text check(voting_round in ('pre','live')), created_at timestamptz default now()
);
create table if not exists public.spectrum_votes (
 id uuid primary key default gen_random_uuid(), nominee_id uuid not null references public.spectrum_nominations(id) on delete cascade,
 member_id uuid not null references auth.users(id) on delete cascade, round text not null check(round in ('pre','live')),
 created_at timestamptz default now()
);
create table if not exists public.spectrum_winners (
 id uuid primary key default gen_random_uuid(), award_year int not null, category_name text not null,
 nominee_name text not null, work_title text, published boolean default false, created_at timestamptz default now()
);
create table if not exists public.spectrum_year_plans (
 id uuid primary key default gen_random_uuid(), award_year int not null, phase text not null, title text not null,
 description text, starts_at timestamptz, ends_at timestamptz, status text default 'planned', created_at timestamptz default now()
);
create table if not exists public.spectrum_broadcasts (
 id uuid primary key default gen_random_uuid(), award_year int not null, title text not null, stream_url text,
 starts_at timestamptz, ends_at timestamptz, status text default 'scheduled', created_at timestamptz default now()
);
create unique index if not exists spectrum_votes_one_per_member_nominee_round on public.spectrum_votes(member_id, nominee_id, round);

alter table public.spectrum_categories enable row level security;
alter table public.spectrum_nominations enable row level security;
alter table public.spectrum_votes enable row level security;
alter table public.spectrum_winners enable row level security;
alter table public.spectrum_year_plans enable row level security;
alter table public.spectrum_broadcasts enable row level security;

drop policy if exists spectrum_categories_public_read on public.spectrum_categories;
create policy spectrum_categories_public_read on public.spectrum_categories for select using (active=true);
drop policy if exists spectrum_nominations_member_insert on public.spectrum_nominations;
create policy spectrum_nominations_member_insert on public.spectrum_nominations for insert to authenticated with check (submitted_by=auth.uid());
drop policy if exists spectrum_nominations_public_finalists on public.spectrum_nominations;
create policy spectrum_nominations_public_finalists on public.spectrum_nominations for select using (status='finalist');
drop policy if exists spectrum_votes_member_insert on public.spectrum_votes;
create policy spectrum_votes_member_insert on public.spectrum_votes for insert to authenticated with check (member_id=auth.uid());
drop policy if exists spectrum_winners_public_read on public.spectrum_winners;
create policy spectrum_winners_public_read on public.spectrum_winners for select using (published=true);
drop policy if exists spectrum_plans_public_read on public.spectrum_year_plans;
create policy spectrum_plans_public_read on public.spectrum_year_plans for select using (true);
drop policy if exists spectrum_broadcast_public_read on public.spectrum_broadcasts;
create policy spectrum_broadcast_public_read on public.spectrum_broadcasts for select using (true);

insert into public.spectrum_categories(name,description,sort_order)
select v.name,v.description,v.sort_order from (values
('Motion Pictures','Feature films and theatrical releases.',1),('Television','Broadcast and cable television.',2),('Streaming','Streaming-first series and programs.',3),('Documentary','Documentary film and series.',4),('Animation','Animated entertainment.',5),('Comedy','Comedy across screen, stage and digital.',6),('Drama','Dramatic storytelling.',7),('Action','Action entertainment.',8),('Horror','Horror entertainment.',9),('Science Fiction & Fantasy','Speculative entertainment.',10),('Short Film','Short-form film.',11),('Music','Music and musical projects.',12),('Recording Artist','Recording artists and groups.',13),('Songwriting','Songwriters and compositions.',14),('Music Video','Music video production.',15),('Live Performance','Concert and live entertainment.',16),('Podcasting','Podcast creators and shows.',17),('Radio / Audio','Radio and audio storytelling.',18),('Digital Creator','Online creators.',19),('YouTube / Online Video','Online video channels and series.',20),('Social Media','Social-first entertainment.',21),('Gaming / Esports','Gaming and esports entertainment.',22),('Voice Acting','Voice performance.',23),('Writing','Entertainment writing.',24),('Screenwriting','Screenwriting.',25),('Directing','Directing.',26),('Producing','Producing.',27),('Cinematography','Cinematography.',28),('Editing','Editing.',29),('Production Design','Production design.',30),('Costume Design','Costume design.',31),('Makeup & Hair','Makeup and hair artistry.',32),('Visual Effects','Visual effects.',33),('Sound Design','Sound design.',34),('Stunt Performance','Stunt performance.',35),('Dance','Dance performance.',36),('Theatre','Theatre productions.',37),('Broadway / Stage','Stage productions.',38),('Stand-Up','Stand-up comedy.',39),('Journalism / Entertainment News','Entertainment journalism.',40),('Sports Entertainment','Sports entertainment.',41),('Children & Family','Children and family entertainment.',42),('Emerging Creator','Emerging talent.',43),('Community Impact','Community-focused entertainment impact.',44),('Lifetime Achievement','Lifetime contribution to entertainment.',45),('CrowRules Community Choice','Community choice award.',46)
) as v(name,description,sort_order) where not exists(select 1 from public.spectrum_categories c where lower(c.name)=lower(v.name));