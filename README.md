# Ojo

Ojo is not fancy. it just does a simple comparison of two sets of screenshots. the idea is that there is a set of tests or scripts that will compile the two sets (for example, one from a master branch and another from a feature branch). running the rake task that `Ojo` adds to the rails app will tell you if the two sets of files differ. the rake task is `ojo:compare[branch_1,branch_2]`.

[![Build Status](https://travis-ci.org/QuantumGeordie/ojo.svg)](https://travis-ci.org/QuantumGeordie/ojo)
[![Code Climate](https://codeclimate.com/github/QuantumGeordie/ojo/badges/gpa.svg)](https://codeclimate.com/github/QuantumGeordie/ojo)
[![Test Coverage](https://codeclimate.com/github/QuantumGeordie/ojo/badges/coverage.svg)](https://codeclimate.com/github/QuantumGeordie/ojo)

## Installation

Add this line to your application's Gemfile:

    gem 'ojo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ojo

## Usage

### Initialization

in a rails initializer do something like this to tell `Ojo` where the files to compare are.

    Ojo.configure do |config|
      config.location = '/path/to/screenshots'
    end

### Screenshotter

you can use whatever method of taking the screenshots you would like. Ojo has a concept of a `screenshotter`. you can define it like so:

    Ojo.screenshotter = lambda do |filename|
      # what ever method of screenshot grabbing you would like
      # for example, using Capybara...
      page.save_screenshot(filename)
    end

then in your script/test you can do `Ojo.screenshot(data_set, screenshot)`. using the screenshotter is not necessary.

    Ojo.screenshot('master', 'login_page')

 really all you need to do is end up with two sets of PNG files that have the same filenames.

### Comparison

After both sets of data have been run, the `Ojo` rake task `ojo:compare[branch_1,branch_2]` can be run to compare the results. as an example, let's say we were making some changes to the login page. we might have an in work `login_page_update` branch that we want to compare to our `master` branch.

#### Example data sets

    /master
       /current_user.png
       /master_only.png
       /signed_in.png
       /test_home.png
       /user.png
    /login_page_update
       /login_update_only.png
       /current_user.png
       /signed_in.png
       /test_home.png
       /user.png

#### run

    >> rake ojo:compare[master,login_page_update]

    +---------------------------------------------------------------------------------------------+
    |                                         Ojo v.1.0.1                                         |
    |                          file location: /path/to/screenshots                                |
    |                                         04/02/2015                                          |
    |                       data sets compared: master & login_page_update                        |
    +---------------------------------------------------------------------------------------------+
    |  File                                                        |   | Magnitude                |
    |--------------------------------------------------------------+---+--------------------------|
    |  current_user.png                                            | F | ████████████████████████ |
    |  user.png                                                    | F | █████████████            |
    |  signed_in.png                                               | P |                          |
    |  test_home.png                                               | P |                          |
    |  master_only.png                                             | - |                          |
    |  login_update_only.png                                       | - |                          |
    +---------------------------------------------------------------------------------------------+
    |                        Results: 2 files were found to be different                          |
    |                       Difference Files at /path/to/screenshots/diff                         |
    +---------------------------------------------------------------------------------------------+
    >> _

you can see here that not everything passed (or was exactly the same) in each test case. the __user__ and __current_user__ cases did not pass. to investigate, you can look at the _diff_ directory under _/path/to/screenshots/_. you will see what differences were found in each test case.

the __Magnitude__ column is a relative representation of the number of pixels found that changed between the two screenshots. it only shows relative levels of _failiness_.

in addition, you can see that there were extra files in each data set. other comparisons are not affected.

### Rake Tasks

    rake ojo:clear:all                   # clear all ojo files INCLUDING all data sets
    rake ojo:clear:diff                  # clear ojo results only
    rake ojo:compare[branch_1,branch_2]  # use ojo to compare two branches
    rake ojo:list                        # list ojo data sets
    rake ojo:location                    # show ojo location setting

the `rake ojo:compare` task can be run without any arguments as well as explicitly stating the data sets/branch names. in this case, the first two valid data sets will be used.

## Contributing

1. Fork it ( https://github.com/QuantumGeordie/ojo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
