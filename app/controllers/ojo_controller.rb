class OjoController < ApplicationController
  before_filter :get_gem_version

  def index
    @branches = Dir[File.join(Ojo.location, '*')].select { |item| File.directory?(item) && File.basename(item) != 'diff' }.map{ |d| File.basename(d) }
  end

  def get_gem_version
    @ojo_gem_version         = Gem.loaded_specs['ojo'].version.to_s
    @parent_application_name = Rails.application.class.to_s.split('::').first
    @ojo_data_location       = Ojo.location
  end
end
