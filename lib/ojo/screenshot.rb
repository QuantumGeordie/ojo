module Ojo

  @screenshotter = nil

  def self.screenshotter=(screenshotter)
    @screenshotter = screenshotter
  end

  def self.screenshotter
    @screenshotter
  end

  def self.screenshot(group_name, base_name)
    raise 'No screenshot method defined for Ojo.screenshoter!' unless @screenshotter
    raise 'No screenshot location defined for Ojo.location!' unless Ojo.configuration.location

    filename = File.join(location, group_name, "#{base_name}.png")

    @screenshotter.call filename
  end
end
