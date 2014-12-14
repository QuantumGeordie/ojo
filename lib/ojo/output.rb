module Ojo
  class Output
    def display_to_console(data)
      format_table data

      failure_count = 0

      data[:results].each_key do |basename|
        file_1 = file_basename(data[:results][basename][:file_1])
        file_2 = file_basename(data[:results][basename][:file_2])

        color       = :blue
        result_text = '--'

        if test_performed?(data[:results][basename])
          same = data[:results][basename][:same]
          color = same ? :green : :red
          result_text = same ? 'PASS' : 'FAIL'
          failure_count += 1 unless same
        end

        one_row file_1, file_2, result_text, color
      end
      format_table_footer failure_count, data
    end

    private

    def format_table_footer(failure_count, data)
      Table.footer(results_message(failure_count == 0, failure_count), :justification => :center)
      Table.footer("Difference Files at #{File.join(data[:location], 'diff')}", :justification => :center)

      Table.tabulate
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
      Table.header("Ojo v.#{VERSION}")
      Table.header("file location: #{data[:location]}")
      Table.header(Date.today.strftime('%m/%d/%Y'))
    end

    def format_table(data)
      format_table_header data

      Table.column(data[:branch_1], :width => 60, :padding => 2, :justification => :left)
      Table.column(data[:branch_2], :width => 60, :padding => 2, :justification => :left)
      Table.column('Results', :width => 11, :justification => :center)
    end

    def one_row(file_1, file_2, result_text, color)
      max_printable_length = 50

      formatted_file_1 = make_printable_name(file_1, max_printable_length)
      formatted_file_2 = make_printable_name(file_2, max_printable_length)

      row_data = [formatted_file_1, formatted_file_2, result_text]
      Table.row(:data => row_data, :color => color)
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
