# Ojo

Ojo is not fancy. it just does a simple comparison of two sets of screenshots. the idea is that there are a set of tests or scripts that will compile the two sets (for example, one from a master branch and another from a feature branch). running the rake task that `Ojo` adds to the rails app will tell you if they two files differ. the rake task is `ojo:compare[branch_1,branch_2`.

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

`Ojo.location = '/path/to/screenshots'`

this location will have sub-directories that have the two sets. you only indicate the parent director.

### Screenshotter

you can use whatever method of taking the screenshots you would like. Ojo has a concept of a `screenshotter`. you can define it like so:

    Ojo.screenshotter = lambda do |filename|
      # what ever method of screenshot grabbing you would like
      # for example, using Capybara...
      page.save_screenshot(filename)
    end

then in your script/test you can do `Ojo.screenshot(data_set, screenshot)`.

    Ojo.screenshot('master', 'login_page')

### Comparison

After both sets of data have been run, the `Ojo` rake task `ojo:compare[branch_1,branch_2]` can be run to compare the results. as an example, let's say we were making some changes to the login page. we might have an in work `login_page_update` branch that we want to compare to our `master` branch.

    >> rake ojo:compare[master,login_page_update]
    +-------------------------------------------------------------------------------------------------+
    |                                               Ojo                                               |
    |                                     /path/to/screenshots                                        |
    |                                           2014-10-14                                            |
    +-------------------------------------------------------------------------------------------------+
    |  master                                  |  login_page_update                       |  Results  |
    |------------------------------------------+------------------------------------------+-----------|
    |  current_user.png                        |  current_user.png                        |   FAIL    |
    |  signed_in.png                           |  signed_in.png                           |   PASS    |
    |  test_home.png                           |  test_home.png                           |   PASS    |
    |  user.png                                |  user.png                                |   FAIL    |
    +-------------------------------------------------------------------------------------------------+
    |                                      Total Results: FAIL                                        |
    +-------------------------------------------------------------------------------------------------+

you can see here that not everything passed (or was exactly the same) in each test case. the `user` and `current_user` cases did not pass. to investigate why, you can look at the `diff` directory under `/path/to/screenshots/`. you will see what differences were found in each test case.

## Contributing

1. Fork it ( https://github.com/QuantumGeordie/ojo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
