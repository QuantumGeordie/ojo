module Ojo
  def self.display_to_console(data)
    Table.header("Ojo v.#{VERSION}")
    Table.header("file location: #{data[:location]}")
    Table.header(Date.today.strftime('%m/%d/%Y'))

    Table.column(data[:branch_1], :width => 60, :padding => 2, :justification => :left)
    Table.column(data[:branch_2], :width => 60, :padding => 2, :justification => :left)
    Table.column('Results', :width => 11, :justification => :center)

    all_same = true
    failure_count = 0

    data[:results].each_key do |basename|
      file_1 = data[:results][basename][:file_1]
      file_1 = File.basename(file_1) if file_1

      file_2 = data[:results][basename][:file_2]
      file_2 = File.basename(file_2) if file_2

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

      one_row file_1, file_2, result_text, color
    end

    Table.footer(results_message(all_same, failure_count), :justification => :center)
    Table.footer("Difference Files at #{File.join(data[:location], 'diff')}", :justification => :center)

    Table.tabulate
  end

  private

  def self.one_row(file_1, file_2, result_text, color)
    max_printable_length = 50

    formatted_file_1 = make_printable_name(file_1, max_printable_length)
    formatted_file_2 = make_printable_name(file_2, max_printable_length)

    row_data = [formatted_file_1, formatted_file_2, result_text]
    Table.row(:data => row_data, :color => color)
  end

  def self.results_message(same, failure_count)
    results_message = ['Results: ']
    results_message << 'All Same' if same
    results_message << "#{failure_count} file#{failure_count > 1 ? 's were' : ' was'} found to be different" unless same
    results_message.join('')
  end

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
