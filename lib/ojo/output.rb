module Ojo
  def self.display_to_console(data)

    max_printable_length = 50
    longest_filename_length = 0

    Table.header("Ojo v.#{VERSION}")
    Table.header("file location: #{data[:location]}")
    Table.header(Date.today.strftime('%m/%d/%Y'))

    Table.column(data[:branch_1], :width => 60, :padding => 2, :justification => :left)
    Table.column(data[:branch_2], :width => 60, :padding => 2, :justification => :left)
    Table.column('Results', :width => 11, :justification => :center)

    all_same = true
    failure_count = 0

    data[:results].each_key do |basename|
      file_1 = File.basename(data[:results][basename][:file_1]) unless data[:results][basename][:file_1].nil?
      file_2 = File.basename(data[:results][basename][:file_2]) unless data[:results][basename][:file_2].nil?
      same = data[:results][basename][:same]

      color = :blue
      result_text = '--'
      if same
        color = :green
        result_text = 'PASS'
      elsif same == false      # need to check for false as nil is possible, but not the same as false. TODO: CHANGE THIS. FEELS YUCKY.
        color = :red
        result_text = 'FAIL'
        all_same = false
        failure_count += 1
      end

      cell_data = result_text

      formatted_file_1 = make_printable_name(file_1, max_printable_length)
      formatted_file_2 = make_printable_name(file_2, max_printable_length)

      row_data = [formatted_file_1, formatted_file_2, cell_data]
      Table.row(:data => row_data, :color => color)
    end

    results_message = ['Results: ']
    results_message << 'All Same' if all_same
    results_message << "#{failure_count} file#{failure_count > 1 ? 's were' : ' was'} found to be different" unless all_same

    Table.footer(results_message.join(''), :justification => :center)
    Table.footer("Difference Files at #{File.join(data[:location], 'diff')}", :justification => :center)

    Table.tabulate
  end

  private

  def self.make_printable_name(input, max_length)
    output = input

    if input && (output.length > max_length)
      spacer = '....'
      how_much_too_long = output.length - max_length
      center_of_string = output.length / 2
      front_of_new_string = output[0..(center_of_string - how_much_too_long/2 - 3)]
      back_of_new_string = output[(center_of_string + how_much_too_long/2 + 3)..output.length]

      output = front_of_new_string + spacer + back_of_new_string
    end

    output
  end
end
