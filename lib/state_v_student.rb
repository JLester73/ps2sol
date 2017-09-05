#
# This file runs all the tests and writes out the CSV
# file in the format needed for VAAP/VGLA uploads.
#

class StateVStudent
  attr_accessor :admin, :last_name, :first_name, :middle_name, :sti, :division,
    :va_schoolid, :test_code, :group_name, :group_code, :birth_date, :grade,
    :gender, :ethnicity, :race, :mil_conn, :student_number, :primnight_rescode, 
    :foster, :n_code, :ell_test_tier, :ell_comp_score, 
    :ell_lit_score, :dis_code, :temp_cond, :formerly_lep, :x_code_b, :x_code_c, 
    :x_code_d, :soa_lep, :soa_trans, :ayp_a, :ayp_b, :ayp_c, :ayp_d,
    :spec_a, :spec_b, :spec_c,
    :rp_code, :local, :local_test, :recovery, :retest, :d_code,
    :term_grad, :proj_grad, :vgla, :vaap, :vsep, :z_c, :z_d, :z_e, :vtln, :tln, 
    :tfn, :eor

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
    @login = nil
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
    @mil_conn = nil
    @student_number = nil
    @primnight_rescode = nil
    @foster = nil
    @n_code = nil
    @ell_test_tier = nil
    @ell_comp_score = nil
    @ell_lit_score = nil
    @dis_code = nil
    @temp_cond = nil
    @formerly_lep = nil
    @x_code_b = nil
    @x_code_c = nil
    @x_code_d = nil
    @soa_lep = nil
    @soa_trans = nil
    @ayp_a = nil
    @ayp_b = nil
    @ayp_c = nil
    @ayp_d = nil
    @spec_a = nil
    @spec_b = nil
    @spec_c = nil
    @rp_code = nil
    @local = nil
    @local_test = nil
    @recovery = nil
    @retest = nil
    @d_code = nil
    @term_grad = nil
    @proj_grad = nil
    @vgla = nil
    @vaap = nil
    @vsep = nil
    @z_c = nil
    @z_d = nil
    @z_e = nil
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
        csv << [@admin, @last_name, @first_name, @middle_name, @login,
        @division, @va_schoolid, @test_code, @group_name, @group_code,
        @birth_date, @grade, @gender, @sti, @ethnicity, @race, @mil_conn, @student_number,
        @primnight_rescode, @foster, @n_code,
        @ell_test_tier, @ell_comp_score, @ell_lit_score, @dis_code, @temp_cond,
        @formerly_lep, @x_code_b, @x_code_c, @x_code_d, @soa_lep, @soa_trans, @ayp_a, 
        @ayp_b, @ayp_c, @ayp_d, @spec_a, @spec_b, @spec_c, @rp_code,
        @local, @local_test, @recovery, @retest, @d_code, @term_grad, @proj_grad, @vgla, 
        @vaap, @vsep, @z_c, @z_d, @z_e, @vtln, 
        @tln, @tfn, @eor]
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

    # 3. First Name (Field Length 12)
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

    # 5. Login ID (See 14.)

    # 6. Division Code (Set by Default)

    # 7. VA School Code (Field Length 4)
    if (@va_schoolid.nil? || @va_schoolid.zero?)
      @errors[:va_schoolid] = "Empty School"
    else
      @va_schoolid = @va_schoolid.to_s.rjust(4, '0')
      if (!@va_schoolid.match(/^[0-9]{4}$/))
        @errors[:va_schoolid] = "School ID must be 4 numbers"
      end
    end

    # 8. Test Code (Field Length 6)
    if (@test_code.nil? || @test_code.empty?)
      @warns[:test_code] = "No Test Code"
    end

    # 9. Group Name (Field Length 20)
    if (@group_name.nil? || @group_name.empty?)
      @warns[:group_name] = "No Group Name"
    else
      # This value can only have A-Z and 0-9
      @group_name = @group_name.gsub(/[^A-Za-z0-9 ]/, '')

      # This is limited to 20 characters 
      @group_name.slice(0, 20)
    end

    # 10. Group Code (Field Length 10)
    if (@group_code.nil? || @group_code.empty?)
      @warns[:group_code] = "No Group Code"
    else
      # Can only have A-Z and 0-9
      @group_code = @group_code.gsub(/[^A-Za-z0-9 ]/, '')

      # Limited to 10 characters
      @group_code = @group_code.slice(0,10)
    end

    # 11. Date if Birth (Field Length 8)
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

    # 12. Grade (Field Length 2)
    if (@grade.nil?)
      @errors[:grade] = "No Grade"
    else
      # Pad grade with a leading zero if necessary
      @grade = @grade.to_s.rjust(2, '0')

      # Valid grades are 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, TT
      if(!@grade.to_s.match(/^(0[3456789]|1[012]|TT)$/))
        @errors[:grade] = "Invalid Grade: #{@grade}"
      end
    end

    # 13. Gender (Field Length 1)
    if (@gender.nil? || @gender.empty?)
      @errors[:gender] = "No Gender"
    else
      @errors[:gender] = "Invalid Gender" if !@gender.match(/^[MF]$/)
    end

    # 14. Student Testing Identifier (Field Length 10)
    if (@sti.nil? || @sti.empty?)
      @errors[:sti] = "No STI"
    else
      @errors[:sti] = "Invalid STI" if @sti.length != 10
    end

    # 15. Ethnicity: Hispanic (Field Length 1)
    if (@ethnicity.nil? || @ethnicity < 0)
      @errors[:ethnicity] = "No Ethnicity Specified"
    else
      if (@ethnicity == 1)
        @ethnicity = 'Y'
      else
        @ethnicity = 'N'
      end
    end

    # 16. Race (Field Length 2) va_ercode
    if (@race.nil? || @race.empty?)
      @errors[:race] = "No Race"
    else
      if (!@race.match(/^([0-2][0-9]|3[0-2])$/))
        @error[:race] = "Invalid Race: #{@race}"
      end
    end

    # 17. Military Connected
    @mil_conn = @mil_conn.to_i
    if (@mil_conn.nil? || @mil_conn < 1 || @mil_conn > 4)
      @errors[:mil_conn] = "Invalid Military Code"
    end	
	
    # 18. Student Number (Field Length 12)
    if (@student_number.nil? || @student_number.zero?)
      @warns[:student_number] = 'No Student Number'
    else
      # Student Numbers must be an integer
      @student_number = @student_number.to_i
      # Field can be no longer than 12 characters
      @student_number = @student_number.to_s.slice(0,12)
    end

    # 19. Student Category - Homeless (Field Length 1)
      if (!@primnight_rescode.nil?)
        if (!@primnight_rescode.to_i.between?(1,4))  
          @errors[:primnight_rescode] = "Invalid PrimNight ResCode"
        end
      end

    # 19. Student Category - Homeless (Field Length 1)
    if (!@primnight_rescode.nil? && !@primnight_rescode.empty?)
      @primnight_rescode = 'Y'
    end

    # 20 Foster Care
    if (!@foster.nil?)
      @foster = "Y"
    end

    # 21. N-Code (Free / Reduced) (Field Length 1)
    if (!@n_code.nil? && !@n_code.empty?) || 
      (!@primnight_rescode.nil? && !@primnight_rescode.empty?)
      @n_code = 'Y'
    end

    # 22. ELL Test Tier (Field Length 1)

    # 23. ELL Composite Score (Field Length 2) Range 10-60

    # 24. ELL Literacy Score (Field Length 2) Range 10-20

    # 25.Disability Code (Field Length 2)
    if (!@dis_code.nil? && !@dis_code.empty?)
      # Pad with leading zero if necessary
      @dis_code = @dis_code.to_s.rjust(2, '0')
      if !@dis_code.match(/(^0[1-9]|1[0234569])$/)
        @errors[:dis_code] = "Invalid Disability Code"
      end
    end

    # 26. Temporary Condition (Set by Default) (Field Length 1)
    
    # 27. Formerly LEP (Set by Default) (Field Length 1)
    if (!@formerly_lep.nil? && !@formerly_lep.empty? && @formerly_lep == 3)
      @formerly_lep = 'Y'
    else
      @formerly_lep = nil
    end
    
    # 28. X Code B (Set by Default) (Field Length 1)

    # 29. X Code C (Set by Default) (Field Length 1)
	
    # 30. X Code D (Set by Default) (Field Length 1)
    
    # 31. SOA Adjustment LEP (Set by Default) (Field Length 1)
    if (!@soa_lep.nil? && !@soa_lep.empty? && @soa_lep == 1)
         @soa_lep = 'Y'
    end
    
    # 32. SOA Adjustment Transfer (Field Length 1)
    if (!@soa_trans.nil? && !@soa_trans.empty? && @soa_trans == 1)
         @soa_trans = 'Y'
    end
    
    # 33. AYP Adjustment A (Field Length 1)
    if (!@ayp_a.nil? && !@ayp_a.empty?)
       if !@ayp_a.match(/^A$/)
         @errors[:ayp_a] = "Invalid AYP-A code"
       end
    end
    
    # 34. AYP Adjustment B (Field Length 1)
    if (!@ayp_b.nil? && !@ayp_b.empty?)
       if !@ayp_b.match(/^B$/)
         @errors[:ayp_b] = "Invalid AYP-B code"
       end
    end
    
    # 35. AYP Adjustment C (Field Length 1)
    if (!@ayp_c.nil? && !@ayp_c.empty?)
       if !@ayp_c.match(/^C$/)
         @errors[:ayp_c] = "Invalid AYP-C code"
       end
    end

    
    # 36. AYP Adjustment D (Field Length 1)
    if (!@ayp_d.nil? && !@ayp_d.empty?)
       if !@ayp_d.match(/^D$/)
         @errors[:ayp_d] = "Invalid AYP-D code"
       end
    end
    
    # 37. Special Code A (Set by Default) (Field Length 1)

    # 38. Special Code B (Set by Default) (Field Length 1)

    # 39. Special Code C (Set by Default) (Field Length 1)
    
    # 40. RP Code (Set by Default) (Field Length 1)
  
    # 41. Local Use Student (Set by Default) (Field Length 9)
	
    # 42. Local Use Test (Set by Default) (Field Length 9)	
    
    # 43. Recovery (Set by Default) (Field Length 1)
    if(!@recovery.nil?)
      @recovery = 'Y'
    end

    # 44. Retest (Field Length 1)
    if (!@retest.nil?)
      @retest = 'Y'
    end
    
    # 45. D Code (Set by Default) (Field Length 1)

    # 46. Term Grad (Set by Default) (Field Length 1)
    
    # 47. Project Graduation (Field Length 1)
    if (!@proj_grad.nil?)
      @proj_grad = 'Y'
    end
    
    # 48. VGLA (Field Length 1)
    if (!@vgla.nil?)
      @vgla = 'Y'
    end

    # 49. VAAP
    if (!@vaap.nil?)
      @vaap = 'Y'
    end

    # 50. VSEP
    if (!@vsep.nil?)
      @vsep = 'Y'
    end

    # 51. Z Code C (Set by Default) (Field Length 1)
    
    # 52. Z Code D (Set by Default) (Field Length 1)

    # 53. Z Code E (Set by Default) (Field Length 1)

    # 52. VTLN (Set by Default) (Field Length 1)
    if (@vtln.nil? || @vtln.empty?)
      @warns[:vtln] = "No VTLN Associated"
    end
    
    # 53. TLN (Set by Default) (Field Length 1)
    
    # 54. TFN (Set by Default) (Field Length 1)
    
    # 55. End of Record (Set by Default) (Field Length 1)

    # Extra Information
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

