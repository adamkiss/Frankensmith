# Composer.json for custom packages

Go [back to docs](https://github.com/adamkiss/Frankensmith/tree/master/docs)

## Example

``` js
{
  // This gets required (regardless of repo name/url)
  "name": "adamkiss/custom-composer-package",
  "description": "Library description (not important for private packages)",
  "authors": [
      {
          "name": "name",
          "email": "email"
      }
  ],

  // Important? Default
  "type": "library",

  // requirements are ok
  "require": {
      "rmccue/requests": ">=1.0"
  },

  // autoloader example (not important)
  "autoload": {
      "classmap": [
          "src/"
      ]
  }
}
```