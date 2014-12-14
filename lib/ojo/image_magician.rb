module Ojo
  class ImageMagician
    def make_magic(command_string)
      output = nil
      status = Open4::popen4(command_string) do |pid, stdin, stdout, stderr|
        output = stderr.read
      end
      output
    end
  end
end
