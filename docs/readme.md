# Readme for v2 (in preparation)

* [Upgrades to customisation of tasks](#upgrades)
* [PHP — Composer and stuff](#php--composer)
* [Deployment](#deployment)

## Upgrades

Let's try Creating whole `Site` object and passing it back to `build.js` (possibly `.coffee`) to do some per-site running stuff: Better naming (ha!) is needed, and also things need *not* to be included.

## PHP & Composer

**composer setup:**
* [composer.json - project](https://github.com/adamkiss/Frankensmith/blob/master/docs/composer-json.md)
* [composer.json - custom package](https://github.com/adamkiss/Frankensmith/blob/master/docs/composer-package-json.md)

## Deployment

**rsync: delay updates**  
Consider simplifying the call to just one (everything), coupled with [`--delay-updates`](https://download.samba.org/pub/rsync/rsync.html), which should (theoretically, at least) copy everything first and then update 