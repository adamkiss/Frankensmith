# Readme for v2 (in preparation)

* [CLI](#cli)
* [Upgrades to customisation of tasks](#upgrades)
* [PHP — Composer and stuff](#php--composer)
* [Deployment](#deployment)

## CLI

This should be split in two projects: Frankensmith (which will basically remain as-is, except with some upgrades to customisation, different naming, different directory structure) and Frankensmith-CLI, which would manage passing data between Site and "global" Frankensmith versions installed. Somehow :D

### Frankensmith-CLI

Take running data from `Cakefile` and create real, `yarn add global …` installable CLI. This should also manage installing of different versions

### Frankensmith

Allow to have more than one Frankensmith installed (Frankensmith1, Frankensmith2, etc.), so I can (if needed) try to run - or work on - older projects, if needed.

## Upgrades

Let's try Creating whole `Site` object and passing it back to `build.js` (possibly `.coffee`) to do some per-site running stuff: Better naming (ha!) is needed, and also things need *not* to be included.

## PHP & Composer

**composer setup:**
* [composer.json - project](https://github.com/adamkiss/Frankensmith/blob/master/docs/composer-json.md)
* [composer.json - custom package](https://github.com/adamkiss/Frankensmith/blob/master/docs/composer-package-json.md)

## Deployment

**rsync: delay updates**  
Consider simplifying the call to just one (everything), coupled with [`--delay-updates`](https://download.samba.org/pub/rsync/rsync.html), which should (theoretically, at least) copy everything first and then update 