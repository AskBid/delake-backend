# README

This Rails API is the backend for this repo [Live-Rewards](https://github.com/AskBid/live-rewards).

* Ruby version
	ruby 2.6.1p33

* Database creation
	To run it needs to connect to a [`cardano-db-sync`](https://github.com/input-output-hk/cardano-db-sync) node.
	It runs a dual database system with one local postgres database and a remote read-only postgres database manteined from the `cardano-db-sync`.
	The connection to the `cardano-db-sync` and the app requires the declaration of few ENV variables in the file `config/local_env.yml` as follow:
	```
	HOST_PG_DATABASE_IP: 
	HOST_PG_DATABASE_USERNAME:
	HOST_PG_DATABASE_PASSWORD:
	HOST_PG_PORT:
	SECRET_KEY_BASE:
	```
	The values depends on the configuration you will have for your `cardano-db-sync`.

	To set up the local postgres database a `rails db:create` + `rails db:migrate` should suffice.



