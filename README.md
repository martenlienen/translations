Translations
============

Edit your translation files in a synchronized way.


Naming
------

1. One translation is your `master`. This file is always complete and serves as a reference for the `slaves`.
2. All translations that are not `master` are `slave`s. This means that they may not be up-to-date and can be synchronized
   with the master using `translate`.

The default master is `en`, but you may alter it using the `-m <locale>` switch.


Usage
-----

Currently there are 6 commands to alter your translation files:

- `add`: Add a new key to all your files
- `update`: Update a key in a single file
- `change`: Change the meaning of a key in a way that requires a re-translation for all locales
- `move`: Move a key around
- `remove`: Remove a key from all files
- `translate`: Translate all keys that are missing from a given file

For more info just run `translations help <command>`.


Requirements
------------

- All your translations are stored in YAML format and one file per locale called `<locale>.yml`
- Optimally you work in a rails project, e.g. your translations are stored in `config/locales`, but you may alter this location with `-d <directory>`
- Optimally you have a master


Missing/Coming Features
----------------

The following features (or whatever comes to your mind) will probably be implemented in the next time:

- Support for Pluralizations
- Support for [Cascading](http://svenfuchs.com/2011/2/11/organizing-translations-with-i18n-cascade-and-i18n-missingtranslations)


Installation
------------

Add this line to your application's Gemfile:

    gem 'translations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install translations


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
