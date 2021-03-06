#
# This file runs all the tests and writes out the CSV
# file in the format needed for Field Test uploads.
#

class StateFTStudent
  attr_accessor :admin, :last_name, :first_name, :middle_name, :login, :sti, 
    :division, :va_schoolid, :test_code, :group_name, :group_code, :birth_date, 
    :grade, :gender, :ethnicity, :race, :student_number, :t1_tas, 
    :primnight_rescode, :neg_del, :n_code, :ell_test_tier, :ell_comp_score, 
    :ell_lit_score, :dis_code, :temp_cond, :x_code_a, :x_code_b, :x_code_c, 
    :soa_lep, :soa_trans, :ayp_a, :ayp_b, :ayp_c, :ayp_d,
    :teched_prep, :teched_parent, :teched_displaced, :teched_nontrad, :spec_a,
    :spec_b, :spec_c, :rp_code, :local, :online, :recovery, :retest, :d_code,
    :term_grad, :proj_grad, :retest_college, :z_a, :z_b, :z_c, :vtln, :tln, 
    :tfn, :eor, :enroll_date, :enroll_code, :withdrawal_date, :withdrawal_code

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
    @sti = nil
    @division = "094"   # 094 is the division's state code
    @va_schoolid = nil
    @test_code = nil
    @group_name = nil
    @group_code = nil
    @birth_date = nil
    @grade = nil
    @gender = nil
    @ethnicity = nil
    @race = nil
    @student_number = nil
    @t1_tas = nil
    @migrant = nil
    @primnight_rescode = nil
    @neg_del = nil
    @n_code = nil
    @ell_test_tier = nil
    @ell_comp_score = nil
    @ell_lit_score = nil
    @dis_code = nil
    @temp_cond = nil
    @xcode_a = nil
    @xcode_b = nil
    @xcode_c = nil
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
    @online
    @recovery = nil
    @retest_college = nil
    @d_code = nil
    @term_grad = nil
    @proj_grad = nil
    @retest = nil
    @z_a = nil
    @z_b = nil
    @z_c = nil
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
        @division, @va_schoolid, @test_code, @group_name, nil,
        @birth_date, @grade, @gender, @sti, @ethnicity, @race, nil, nil, nil, 
        nil, nil, nil, nil, nil, nil, nil, @eor]
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

    # 7. Test Code (Field Length 6)
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

      # Valid grades are 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, TT
      if(!@grade.to_s.match(/^(0[3456789]|1[012]|TT)$/))
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

    # 16. Student Number (Field Length 12)
    if (@student_number.nil? || @student_number.zero?)
      @warns[:student_number] = 'No Student Number'
    else
      # Student Numbers must be an integer
      @student_number = @student_number.to_i
      # Field can be no longer than 12 characters
      @student_number = @student_number.to_s.slice(0,12)
    end

    # 18. Title I/Targeted Assistance Services (Field Length 1)
    #if (!@t1_tas.nil? && !@t1_tas.empty?)
    #  if (!@t1_tas.to_s.matches(/^[1-4]$/))
    #    @errors[:t1_tas] = "Invalid Title I TAS code"
    #  end
    #end

    # 19. Student Category - Homeless (Field Length 1)
    if (!@primnight_rescode.nil? && !@primnight_rescode.empty?)
      @primnight_rescode = 'Y'
    end

    # 20. Student Category - Neglected or Deleinquent (Field Length 1)
    if (!@neg_del.nil? && !@neg_del.empty?)
      @neg_del = 'Y'
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
    
    # 28. X Code B (Set by Default) (Field Length 1)

    # 29. X Code C (Set by Default) (Field Length 1)
    
    # 30. SOA Adjustment LEP (Set by Default) (Field Length 1)
    #if (!@soa_lep.nil? && !@soa_lep.empty? && @soa_lep == 1)
    #     @soa_lep = 'Y'
    #end
    
    # 31. SOA Adjustment Transfer (Field Length 1)
    #if (!@soa_trans.nil? && !@soa_trans.empty? && @soa_trans == 1)
    #     @soa_trans = 'Y'
    #end
    
    # 32. AYP Adjustment A (Field Length 1)
    #if (!@ayp_a.nil? && !@ayp_a.empty?)
    #   if !@ayp_a.match(/^A$/)
    #     @errors[:ayp_a] = "Invalid AYP-A code"
    #   end
    #end
    
    # 33. AYP Adjustment B (Field Length 1)
    #if (!@ayp_b.nil? && !@ayp_b.empty?)
    #   if !@ayp_b.match(/^B$/)
    #     @errors[:ayp_b] = "Invalid AYP-B code"
    #   end
    #end
    
    # 34. AYP Adjustment C (Field Length 1)
    #if (!@ayp_c.nil? && !@ayp_c.empty?)
    #   if !@ayp_c.match(/^C$/)
    #     @errors[:ayp_c] = "Invalid AYP-C code"
    #   end
    #end

    
    # 35. AYP Adjustment D (Field Length 1)
    #if (!@ayp_d.nil? && !@ayp_d.empty?)
    #   if !@ayp_d.match(/^D$/)
    #     @errors[:ayp_d] = "Invalid AYP-D code"
    #   end
    #end
    
    # 36. Special Code A (Set by Default) (Field Length 1)

    # 37. Special Code B (Set by Default) (Field Length 1)

    # 38. Special Code C (Set by Default) (Field Length 1)
    
    # 39. RP Code (Set by Default) (Field Length 1)
  
    # 40. Local Use (Set by Default) (Field Length 9)
    
    # 41. Online Testing (Field Length 1)
    if (!@admin.nil? && (@admin.slice(0,2) =~ /^wr/))
      @online = nil 
    else
      @online = 'Y'
    end
    
    # 42. Recovery (Set by Default) (Field Length 1)
    
    # 43. Retest (Field Length 1)
    #if (!@retest.nil?)
    #  @retest = 'Y'
    #end
    
    # 44. D Code (Set by Default) (Field Length 1)

    # 45. Term Grad (Set by Default) (Field Length 1)
    
    # 46. Project Graduation (Field Length 1)
    
    # 47. Retest for College Readiness (Field Length 1)

    # 48. Z Code A (Set by Default) (Field Length 1)
    
    # 49. Z Code B (Set by Default) (Field Length 1)

    # 50. Z Code C (Set by Default) (Field Length 1)

    # 51. VTLN (Set by Default) (Field Length 1)
    if (@vtln.nil? || @vtln.empty?)
      @warns[:vtln] = "No VTLN Associated"
    end
    
    # 52. TLN (Set by Default) (Field Length 1)
    
    # 53. TFN (Set by Default) (Field Length 1)
    
    # 54. End of Record (Set by Default) (Field Length 1)

    # Extra Information
    #if (@enroll_date.nil? || @enroll_date.empty?)
    #  @errors[:enroll_date] = "No Enrollment Date"
    #else
    #  e_year = @enroll_date.slice(0, 4)
    #  e_month = @enroll_date.slice(5, 2)
    #  e_day = @enroll_date.slice(8, 2)
    #  @enroll_date = "#{e_month}/#{e_day}/#{e_year}"
    #end
    
    #if (@enroll_code.nil? || @enroll_code.empty?)
    #  @errors[:enroll_code] = "No Enrollment Code"
    #else
    #  @enroll_code.slice(0, 16)
    #end
    
    # Only include withdrawal date if there is a withdrawal code
    #if (!@withdrawal_code.nil?)
    #  if (@withdrawal_date.nil?)
    #    @errors[:withdrawal_date] = "No Withdrawal Date"
    #  else
    #    w_year = @withdrawal_date.slice(0, 4)
    #    w_month = @withdrawal_date.slice(5, 2)
    #    w_day = @withdrawal_date.slice(8, 2)
    #    @withdrawal_date = "#{w_month}/#{w_day}/#{w_year}"
    #  end
    #end     
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

