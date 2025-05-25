# INFSUS-TimeMaster
Konačna verzija 3. zadaće u okviru kolegija Informacijski sustavi

## Pokretanje backend servera
- potrebno je instalirati `ruby version 3.2.5` -> preporuceno je preko `rbenv` managera
- potrebno je imati instalirati `rails version 7.1.1`
- pozicionirati se u backend direktorij i pokrenuti naredbe: 
  - `gem install bundler`
  - `bundle install`
- pobrinuti se da postoji postgreSQL server sa postgres userom i postgres passwordom za local development
  - ako treba neka druga konfiguracija za bazu (drugi user ili password) onda pomocu naredbi:
  - `EDITOR="code --wait" rails credentials:edit` editirati konekciju za development bazu (user, password, port) 
  - `EDITOR="code --wait" bin/rails credentials:edit --environment test` editirati konekciju za test bazu (user, password, port)
- zatim pokrenuti sljedece naredbe (naredbe ce kreirati development i test bazu, test baza koristit ce se za vrcenje unit testova):
  - `rails db:prepare`
  - `rails db:migrate`
  - `RAILS_ENV=test rails db:prepare`
- pokrenuti naredbu `rails s` za pokretanje servera
- pokretanje unit testova (server ne mora biti upaljen): `bundle exec rspec`

## Pokretanje frontend servera
- Korisnik mora imati instaliran Node.js i npm.
   - Provjera verzije: `node -v` i `npm -v`

- pozicionirati se u folder direktorij
- Prva instalacija (samo prvi put):
  - `npm install`
- Pokretanje aplikacije:
  - `npm run dev`
- Aplikacija će biti dostupna na: `http://localhost:5173/`

## Pokretanje integracijskih testova:
- Instalirati Playwright ako nije već instaliran: `npx playwright install`
- backend server mora biti upaljen u test enviromentu: `RAILS_ENV=test rails s`
- frontend server mora biti upaljen: `npm run dev`
- Pokreni sve testove: `npx playwright test`
- Pokretanje testova u pregledniku (debug način): `npx playwright test --headed`
