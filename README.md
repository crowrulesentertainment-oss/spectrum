# Spectrum Awards

**Every Voice. Every Talent. Every Spectrum.**

Spectrum Awards is a worldwide annual awards program presented by CrowRules Entertainment. The public website is a static HTML/CSS/JavaScript experience hosted through GitHub Pages. The platform is designed around a digital-first annual ceremony and 100% public voting for competitive awards.

## Live site

- Website: https://crowrulesentertainment-oss.github.io/spectrum/
- Repository: https://github.com/crowrulesentertainment-oss/spectrum
- Administration: https://crowrulesentertainment-oss.github.io/spectrum/admin/

## Creative direction

- Luxury cinematic presentation: black, gold and vivid spectrum accents.
- Signature award: Golden Raven with Spectrum Crystal.
- Photorealistic event environments and real-world entertainment scenes.
- Worldwide participation and annual award seasons.
- Digital-first ceremony with red carpet, live performances, backstage interviews, afterparty and worldwide watch parties.
- Digital nominee/winner certificates and a Hall of Fame.

## Public pages currently published

- `index.html` — homepage
- `about.html` — mission and vision
- `awards.html` — award program
- `categories.html` — proposed award divisions
- `nominees.html` — nominee information
- `ceremony.html` — annual digital-first ceremony
- `red-carpet.html` — arrivals and interviews
- `hall-of-fame.html` — special recognition
- `rules.html` — voting principles and rules preview
- `contact.html` — official inquiries

Shared assets:
- `assets/css/site.css`
- `assets/js/site.js`

## Existing platform infrastructure

The existing `admin/index.html` is retained. It uses the CrowRules Universal Admin authentication integration and the existing CrowRules Supabase project. The existing awards tables referenced by the administration workspace are:

- `crowrules_award_seasons`
- `crowrules_award_nominations`
- `crowrules_award_nominees`
- `crowrules_award_votes`

Do not create duplicate awards tables or replace the existing authentication integration without a reviewed migration plan. Do not put Supabase service-role credentials in this static repository. All sensitive operations must be validated server-side and protected by Supabase Row Level Security.

## Publication and data integrity

- No launch or ceremony date is announced until approved.
- No nominees or winners are fabricated for preview pages.
- The category divisions shown on the public site are a program preview, not a claim that a voting round is open.
- Competitive winners are intended to be determined exclusively by eligible public votes.
- Final eligibility, nomination, voting, tie, audit and results-certification rules must be published before voting opens.
- Hall of Fame and special honors are separate from competitive public-voted categories.

## Development roadmap

1. Public identity, shared navigation and responsive public pages.
2. Review existing Supabase awards schema and Universal Membership integration.
3. Connect categories, seasons, approved nominees and nomination workflows to the existing data model.
4. Implement and test secure server-side public voting, receipts and audit controls.
5. Build ceremony, broadcast, red carpet, backstage and watch-party operations.
6. Implement certificate issuance/verification, Hall of Fame and archives.
7. Conduct accessibility, security, privacy, mobile and voting-integrity testing before launch.

## Deployment

The site is designed for GitHub Pages from the repository's `main` branch. Static assets use relative paths so they work from the `/spectrum/` project subpath.

**Launch date: To be announced.**
