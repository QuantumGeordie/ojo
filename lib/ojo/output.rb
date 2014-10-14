module Ojo
  def self.display_to_console(data)
    Table.header('Ojo')
    Table.header(data[:location])
    Table.header(Date.today.to_s)

    Table.column(data[:branch_1], :width => 40, :padding => 2, :justification => :left)
    Table.column(data[:branch_2], :width => 40, :padding => 2, :justification => :left)
    Table.column('Results', :width => 11, :justification => :center)

    all_same = true

    data[:results].each_key do |basename|
      same = data[:results][basename][:same]
      all_same = all_same && same
      cell_data = {:data => same ? 'PASS' : 'FAIL', :color => same ? :green : :red}
      Table.row([File.basename(data[:results][basename][:file_1]), File.basename(data[:results][basename][:file_2]), cell_data])
    end

    Table.footer("Total Results: #{all_same ? 'PASS' : 'FAIL'}", :justification => :center)

    Table.tabulate
  end
end
