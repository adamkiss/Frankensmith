# Composer.json

Go [back to docs](https://github.com/adamkiss/Frankensmith/tree/master/docs)

## Example

``` js
{
    // this might be whatever. composer install/upd. works anyway.
    "name": " organisation / package ",
    "description": "",
    "type": "project",
    "authors": [
        {
            "name": "name",
            "email": "email"
        }
    ],

    // this will basically add another location for requirements
    "repositories": [
        {"type": "vcs", "url": "https://github.com/adamkiss/watwatwat"}
    ],
    // requirements
    "require": {
        "phpunit/php-timer": "^1.0", // composer add…
        "adamkiss/custom-composer-package": "dev-master" //this is from repos
    },
    // this is: 'dist' and moving stuff deeper into tree
    "config": {
        "preferred-install": "dist",
        "vendor-dir": "include/vendor",
        "bin-dir": "include/vendor/bin"
    },
}
```