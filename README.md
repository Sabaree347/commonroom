# Commonroom

Commonroom is a small, real-time group chat built with Ruby on Rails. People can create an account, join the shared room, and exchange messages that are broadcast to other open room sessions.

## What It Does

- Account registration, sign-in, and sign-out with Devise.
- One shared room available to signed-in users.
- Live message updates with Turbo Streams and Action Cable.
- Message timestamps and sender names.
- Message validation: content is required and limited to 1,000 characters.
- Responsive chat and account screens.
- SQLite for local development and the current single-instance deployment setup.

## Use Cases

Commonroom is a starting point for small groups that need one simple, shared conversation space:

- A project team coordinating lightweight updates or a daily check-in.
- A class or study group discussing assignments and sharing questions.
- A volunteer group organizing a short-term activity.
- An event or workshop providing attendees with a live backchannel.
- A prototype for learning Rails authentication, persistence, and real-time broadcasts.

The current MVP has one global room. Every signed-in user can read its messages. It does not yet provide private messages, multiple rooms, file uploads, moderation tools, message search, or online-presence tracking. Do not use it for conversations that require room-level privacy or mature moderation controls without adding those features first.

## Requirements

- Ruby `4.0.7` (see `.ruby-version`).
- Bundler, installed with RubyGems.
- SQLite 3. On Linux, install the SQLite development package if the `sqlite3` gem cannot compile.
- Node.js is not required for the current Import Maps/Turbo frontend.

The application uses Rails `8.1.4`, Devise, Turbo Rails, and SQLite. The committed `Gemfile.lock` records the exact dependency resolution.

## Run Locally

From the project directory:

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

Open `http://localhost:3000`, create an account, and start chatting. The root URL opens the room and redirects signed-out visitors to sign-in.

On Windows PowerShell, if the `bin/rails` launcher is not recognized, run the same Rails commands through Ruby, for example:

```powershell
ruby bin/rails db:prepare
ruby bin/rails server
```

Alternatively, `bin/setup --skip-server` installs dependencies and prepares the database. Then start the server with `bin/rails server`.

## Configuration And Data

- Development and test databases are SQLite files under `storage/`; these local files are excluded from Git.
- `bin/rails db:prepare` creates or migrates the database. Use `bin/rails db:migrate` after adding a migration.
- `bin/rails db:reset` is destructive: it drops and recreates the development database.
- Never commit `config/master.key`, `.kamal/secrets`, or environment files. Supply `RAILS_MASTER_KEY` through your deployment platform when production credentials are needed.
- Development Action Cable uses the in-process async adapter. Production `config/cable.yml` selects Redis and expects `REDIS_URL`; provision Redis and a compatible Redis adapter dependency before deploying.
- The production database is also configured as SQLite. Keep the SQLite file on persistent storage and use a single application instance; move to a client/server database before scaling across multiple app hosts.

## Tests And Checks

Run the test suite:

```sh
bin/rails db:test:prepare test
```

Run the focused chat tests:

```sh
bin/rails test test/models/message_test.rb test/controllers/messages_controller_test.rb
```

Useful CI checks:

```sh
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

GitHub Actions runs security scans, lint, tests, and system tests for pushes to `master` and pull requests.

## Production Deployment

The repository includes a production-oriented Dockerfile and Kamal configuration, but the Kamal host and registry values are placeholders. Before deploying:

1. Configure a real server, image name, and container registry in `config/deploy.yml`.
2. Configure `RAILS_MASTER_KEY` as a deployment secret. Do not add the key to the repository.
3. Configure Redis and `REDIS_URL` for production Action Cable, and add the Redis client dependency required by the selected adapter.
4. Keep `/rails/storage` on persistent, backed-up storage. The current SQLite production database must not live only in an ephemeral container filesystem.
5. Review TLS, backups, monitoring, and single-instance limits for your deployment.

Build the production image with:

```sh
docker build -t commonroom .
```

After completing the Kamal configuration and secrets, use the standard Kamal workflow (`bin/kamal setup` for initial provisioning, then `bin/kamal deploy`). Do not deploy with the placeholder host or registry settings.

## Project Layout

- `app/models`: users and validated chat messages.
- `app/controllers`: authenticated room display and message creation.
- `app/views`: shared layout and chat interface.
- `app/assets/stylesheets/application.css`: application and responsive chat styles.
- `config/routes.rb`: Devise routes, message endpoints, and the room root.
- `db/migrate`: database schema changes.
- `test`: model, controller, and system tests.
- `.github/workflows/ci.yml`: automated checks.
