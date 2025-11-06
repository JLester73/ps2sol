require 'csv'

# 2016-04-25 by Jason Lester

# Delete the old output file if it exists
File.delete("output.csv") if File::exists?("output.csv")

# Loop through sections file and chop out the period expression to just the period number
CSV.foreach('sections.csv') do |row|
  expression = row[5]
  period = expression[0]
  # Create section ID by concatenating course and section numbers
  section = row[2] + "-" + row[3]

  # Write out the output file with the updated period
  CSV.open("output.csv", "a", {:force_quotes=>true}) do |csv|
    csv << [row[0],row[1],row[2],section,row[4],period,row[6],row[7],row[8],row[9]]
  end
end
