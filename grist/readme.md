# setting up grist in dev env

**NB - there are private keys and passwords in here.  I know that! DO NOT USE THEM ANYWHERE BUT LOCAL DEV! Yes, all caps. You've been warned.**

Some quick notes about what I did to get my local dev env going:
* read [the forum post](https://community.getgrist.com/t/grist-core-multi-user-docker-setup/666) about getting it set up in docker to understand the problem space
* run [the single container grist](https://github.com/gristlabs/grist-core/#using-grist) in docker to ensure it works stand alone, then kill it after successful testing
* [install authentik](https://goauthentik.io/docs/installation/docker-compose) via `docker-compose up` and some persistent files: [.env](.env) and [docker-compose.yml](docker-compose.yml).
* Prep my grist env vars in (grist.env)[grist.env] based off the forum post on first point. An important one was to set `GRIST_SINGLE_ORG` to be something custom and not the default `docs`. I used `medic`. This limits anonymous access.
* go to authenik at https://localhost/if/flow/initial-setup/ to set admin password
* follow the forum post create a "grist" service provider. 
* it says to create separate verification certificates than the signing certificate.  not true! you can be lazy and insucure and just use the auto-created self-signed one for both.
* Boot grist container with the (docker.grist.run.sh)[docker.grist.run.sh] one line bash script.
* grist should be running at `http://localhost:8484` and authentik at `https://localhost:9443`
* To create a new user that's not your admin user:
   * create a user in authentic `bob@bob.bob`
   * "impersonate" them so you can then go to edit their profile and set their password
   * as the admin user in `grist`, manage your team and create a user with the matching email `bob@bob.bob`
   * got to `http://localhost:8484` and you should get redirected to login on authentik
