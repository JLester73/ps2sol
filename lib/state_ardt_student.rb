#
# This file runs all the tests and writes out the CSV
# file in the format needed for ARDT uploads.
#

class StateARDTStudent
  attr_accessor :admin, :last_name, :first_name, :middle_name, :sti, 
    :division, :va_schoolid, :test_code, :group_name, :group_code, :birth_date, 
    :grade, :gender, :ethnicity, :race, :dis_code, :lep_code, :ari_code,
    :local_code_a, :local_code_1, :state_code_a, :state_code_1, :vtln, :tln, 
    :tfn, :eor, :student_number, :enroll_date, :enroll_code, :withdrawal_date, 
    :withdrawal_code

  attr_reader :errors, :warns

  def initialize(&block)
    @valid = false      # This object is not valid by default
    @errors = Hash.new  # Holds errors accumulated during validation
    @warns = Hash.new   # Holds warnings accumulated during validation

    # Set Default Values
    @admin = nil
    @last_name = nil
    @first_name = nil
    @middle_name = nil
    @division = "094"   # 094 is the division's state code
    @va_schoolid = nil
    @test_code = nil
    @group_name = nil
    @group_code = nil
    @birth_date = nil
    @grade = nil
    @gender = nil
    @sti = nil
    @ethnicity = nil
    @race = nil
    @dis_code = nil
    @lep_code = nil
    @ari_code = nil
    @local_code_a = nil
    @local_code_1 = nil
    @state_code_a = nil
    @state_code_1 = nil
    @vtln = nil
    @tln = nil
    @tfn = nil
    @eor = 'Y'

    instance_eval &block if block_given?
  end

  # Takes the student and writes it out in the State specified format
  def to_csv
    valid = valid?
    if (valid)
      CSV.open("#{@va_schoolid.to_s.to_i}-students.csv", 'a+') do |csv|
        csv << [@admin, @last_name, @first_name, @middle_name, 
        @division, @va_schoolid, @test_code, @group_name, @group_code,
        @birth_date, @grade, @gender, @sti, @ethnicity, @race, @dis_code, 
        @lep_code, @ari_code, @local_code_a, @local_code_1, @state_code_a,
        @state_code_1, @vtln, @tln, @tfn, @eor]
      end
      return(valid)
    end
  end

  def validate

    # 1. Administration (Field Length 8)
    if(@admin.nil? || @admin.empty?)
      @errors[:admin] = "Empty Test Administration"
    end

    # 2. Last Name (Field Length 11)
    if(@last_name.nil? || @last_name.empty?)
      @errors[:last_name] = "Empty Last Name"
    else
      @last_name = @last_name.slice(0, 32) if @last_name.length > 32
    end

    # 3. First Name (Field Length 9)
    if(@first_name.nil? || @first_name.empty?)
      @errors[:first_name] = "Empty First Name"
    else
      @first_name = @first_name.slice(0, 32) if @first_name.length > 32
    end

    # 4. Middle Initial (Field Length 1)
    if(@middle_name.nil? || @middle_name.empty?)
      @warns[:middle_name] = "Empty Middle Name"
    else
      @middle_name = @middle_name.slice(0, 1) if @middle_name.length > 1
    end

    # 5. Division Code (Set by Default)

    # 6. VA School Code (Field Length 4)
    if (@va_schoolid.nil? || @va_schoolid.zero?)
      @errors[:va_schoolid] = "Empty School"
    else
      @va_schoolid = @va_schoolid.to_s.rjust(4, '0')
      if (!@va_schoolid.match(/^[0-9]{4}$/))
        @errors[:va_schoolid] = "School ID must be 4 numbers"
      end
    end

    # 7. Test Code (Set by Default) (Field Length 6)
    if (@test_code.nil? || @test_code.empty?)
      @warns[:test_code] = "No Test Code"
    end

    # 8. Group Name (Field Length 20)
    if (@group_name.nil? || @group_name.empty?)
      @warns[:group_name] = "No Group Name"
    else
      # This value can only have A-Z and 0-9
      @group_name = @group_name.gsub(/[^A-Za-z0-9 ]/, '')

      # This is limited to 20 characters 
      @group_name.slice(0, 20)
    end

    # 9. Group Code (Field Length 10)
    if (@group_code.nil? || @group_code.empty?)
      @warns[:group_code] = "No Group Code"
    else
      # Can only have A-Z and 0-9
      @group_code = @group_code.gsub(/[^A-Za-z0-9 ]/, '')

      # Limited to 10 characters
      @group_code = @group_code.slice(0,10)
    end

    # 10. Date if Birth (Field Length 8)
    if (@birth_date.nil? || @birth_date.empty?)
      @errors[:birth_date] = "No Birthdate"
    else
      b_year = @birth_date.slice(0, 4)
      b_month = @birth_date.slice(5, 2)
      b_day = @birth_date.slice(8, 2)
      now = DateTime.now
      bday = DateTime.new(b_year.to_i, b_month.to_i, b_day.to_i)
      diff = now - bday
      if ((now - bday).to_i > 0)
        @birth_date = b_month << b_day << b_year
      else
        @errors[:birth_date] = "Birthdate: #{b_month}/#{b_day}/#{b_year}"
      end
    end

    # 11. Grade (Field Length 2)
    if (@grade.nil?)
      @errors[:grade] = "No Grade"
    else
      # Pad grade with a leading zero if necessary
      @grade = @grade.to_s.rjust(2, '0')

      # Valid grades are 03, 04, 05, 06, 07, 08, 09, 10
      if(!@grade.to_s.match(/^(0[3456789]|1[0])$/))
        @errors[:grade] = "Invalid Grade: #{@grade}"
      end
    end

    # 12. Gender (Field Length 1)
    if (@gender.nil? || @gender.empty?)
      @errors[:gender] = "No Gender"
    else
      @errors[:gender] = "Invalid Gender" if !@gender.match(/^[MF]$/)
    end

    # 13. Student Testing Identifier (Field Length 10)
    if (@sti.nil? || @sti.empty?)
      @errors[:sti] = "No STI"
    else
      @errors[:sti] = "Invalid STI" if @sti.length != 10
    end

    # 14. Ethnicity: Hispanic (Field Length 1)
    if (@ethnicity.nil? || @ethnicity < 0)
      @errors[:ethnicity] = "No Ethnicity Specified"
    else
      if (@ethnicity == 1)
        @ethnicity = 'Y'
      else
        @ethnicity = 'N'
      end
    end

    # 15. Race (Field Length 2) va_ercode
    if (@race.nil? || @race.empty?)
      @errors[:race] = "No Race"
    else
      if (!@race.match(/^([0-2][0-9]|3[0-2])$/))
        @error[:race] = "Invalid Race: #{@race}"
      end
    end

    # 16. Disability Code (Field Length 2)
    if (!@dis_code.nil? && !@dis_code.empty?)
      # Pad with leading zero if necessary
      @dis_code = @dis_code.to_s.rjust(2, '0')
      if !@dis_code.match(/(^0[1-9]|1[0234569])$/)
        @errors[:dis_code] = "Invalid Disability Code"
      end
    end

    # 17. LEP Code
    if (!@lep_code.nil? && !@lep_code.empty? && @lep_code.to_s == '1')
      @lep_code = 'Y'
    else
      @lep_code = nil
    end

    # 18. ARI Intervention Code: (Set by Default) (Field ength 1)
    # 19. Local Code A: Student (Set by Default) (Blank or A-Z0-9) (Field Length 10)
    # 20. Local Code 1: Test (Set by Default) (Blank or A-Z0-9) (Field Length 10)
    # 21. State Code A: Student (Set by Default) (Blank or A-Z0-9) (Field Length 10)
    # 22. State Code 1: Test (Set by Default) (Blank or A-Z0-9) (Field Length 10)
    # 23. Code VTLN: Teacher Licensure Number (Field Length 15)
    if (@vtln.nil? || @vtln.empty?)
      @warns[:vtln] = "No VTLN Associated"
    end

    # 24. Code TLN: Teacher Last Name (Set By Default) (Field Length 40)
    # 25. Code TFN: Teacher First Name (Set By Default) (Field Length 25)
    # 26. End of Record (Set By Default) (Field Length 1)

  end

  def valid?
    # Clear out errors and warnings
    @errors.clear
    @warns.clear

    # Run validation
    validate

    # Valid if no errors
    return @errors.empty?
  end
end

