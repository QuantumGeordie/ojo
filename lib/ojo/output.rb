module Ojo
  class Output
    include Collimator::Table
    attr_reader :magnitude_max

    def initialize(magnitude_max)
      @magnitude_max = magnitude_max
    end

    def display_to_console(data)
      format_table data

      failure_count = 0

      data[:results].each do |result|
        filename = file_basename(result[:file_1]) || file_basename(result[:file_2])

        color       = :blue
        result_text = '-'
        pixel_count = '-'

        if test_performed?(result)
          same = result[:same]
          pixel_count = result[:not_same_pixel_count].to_s
          color = if same
                    :green
                  else
                    pixel_count.to_i > 3 ? :red : :yellow
                  end
          unless same
            if pixel_count == 0
              pixel_count = 1
            end
          end
          result_text = same ? 'P' : 'F'
          failure_count += 1 unless same
        end

        one_row filename, result_text, color, pixel_count
      end
      format_table_footer failure_count, data
    end

    private

    def format_table_footer(failure_count, data)
      Collimator::Table.footer(results_message(failure_count == 0, failure_count), :justification => :center)
      Collimator::Table.footer("Difference Files at #{File.join(data[:location], 'diff')}", :justification => :center)

      Collimator::Table.tabulate
    end

    def file_basename(filename)
      out = filename
      out = File.basename(filename) unless out.nil?
      out
    end

    def test_performed?(data)
      !data[:same].nil?
    end

    def format_table_header(data)
      Collimator::Table.header("Ojo v.#{VERSION}")
      Collimator::Table.header("file location: #{data[:location]}")
      Collimator::Table.header(Date.today.strftime('%m/%d/%Y'))
      Collimator::Table.header("data sets compared: #{data[:branch_1]} & #{data[:branch_2]}")
    end

    def format_table(data)
      format_table_header data

      Collimator::Table.column('File', :width => 60, :padding => 2, :justification => :left)
      Collimator::Table.column('', :width => 3, :justification => :center)
      Collimator::Table.column('Magnitude', :width => @magnitude_max + 1, :padding => 1, :justification => :left)
    end

    def one_row(file, result_text, color, magnitude = 0)
      max_printable_length = 50
      bar_character = "\u2588"
      magnitude_bar = bar_character * (magnitude.to_i > @magnitude_max ? @magnitude_max : magnitude.to_i)

      formatted_file = make_printable_name(file, max_printable_length)

      row_data = [formatted_file, result_text, magnitude_bar]
      Collimator::Table.row(:data => row_data, :color => color)
    end

    def results_message(same, failure_count)
      results_message = ['Results: ']
      results_message << 'All Same' if same
      results_message << "#{failure_count} file#{failure_count > 1 ? 's were' : ' was'} found to be different" unless same
      results_message.join('')
    end

    def make_printable_name(input, max_length)
      output = input || ''
  
      if output.length > max_length
        how_much_too_long = output.length - max_length
        center_of_string = output.length / 2
        front_of_new_string = output[0..(center_of_string - how_much_too_long/2 - 3)]
        back_of_new_string = output[(center_of_string + how_much_too_long/2 + 3)..output.length]
  
        output = "#{front_of_new_string}....#{back_of_new_string}"
      end
  
      output
    end
  end
end
