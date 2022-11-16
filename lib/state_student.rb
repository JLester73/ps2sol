#
# This file runs all the tests and writes out the CSV
# file in the format needed for main SOL testing uploads.
#

class StateStudent
  attr_accessor :admin, :last_name, :first_name, :middle_name, :sti, :division,
    :va_schoolid, :test_code, :group_name, :group_code, :birth_date, :grade,
    :gender, :ethnicity, :race, :mil_conn, :mop_flag, :mop_resdiv,
	:student_number, :primnight_rescode, 
    :foster, :n_code, :ell_comp_score, 
    :dis_code, :temp_cond, :formerly_lep, :x_code_b, :x_code_c, :x_code_d, 
    :soa_lep, :soa_trans, :recent_el, 
    :local, :local_test, :online, :session_name, :recovery, :retest, :slife,
    :term_grad, :proj_grad, :par_req, :z_e, :z_f, :z_g, :vtln, :tln, 
    :tfn, :pnp, :eor

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
	@mop_flag = nil
	@mop_resdiv = nil
    @student_number = nil
    @primnight_rescode = nil
    @foster = nil
    @n_code = nil
    @ell_comp_score = nil
    @dis_code = nil
    @temp_cond = nil
    @formerly_lep = nil
    @xcode_b = nil
    @xcode_c = nil
    @xcode_d = nil
    @soa_lep = nil
    @soa_trans = nil
    @recent_el = nil
    @local = nil
    @local_test = nil
    @online
	@slife = nil	
	@session_name = nil
    @recovery = nil
    @retest = nil
	@filler = nil
    @term_grad = nil
    @proj_grad = nil
    @par_req = nil
    @z_e = nil
	@z_f = nil
    @z_g = nil	
    @vtln = nil
    @tln = nil
    @tfn = nil
	@pnp = nil
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
        @birth_date, @grade, @gender, @sti, @ethnicity, @race, @mil_conn,
		@mop_flag, @mop_resdiv, @filler,
        @student_number, @primnight_rescode, @foster, @n_code,
        @ell_comp_score, @dis_code, @temp_cond,
        @formerly_lep, @x_code_b, @x_code_c, @x_code_d, @soa_lep, @soa_trans,
        @recent_el, @local, @local_test, 
        @online, @session_name, @recovery, @retest, @slife, 
        @term_grad, @proj_grad, @par_req, @z_e, @z_f, @z_g, @vtln, 
        @tln, @tfn, @pnp, @eor]
      end
      return(valid)
    end
  end

  def validate

    # 1. Administration (Field Length 8)
    if(@admin.nil? || @admin.empty?)
      @errors[:admin] = "Empty Test Administration"
    end

    # 2. Last Name (Field Length 25)
    if(@last_name.nil? || @last_name.empty?)
      @errors[:last_name] = "Empty Last Name"
    else
      @last_name = @last_name.slice(0, 25) if @last_name.length > 25
    end

    # 3. First Name (Field Length 15)
    if(@first_name.nil? || @first_name.empty?)
      @errors[:first_name] = "Empty First Name"
    else
      @first_name = @first_name.slice(0, 15) if @first_name.length > 15
    end

    # 4. Middle Initial (Field Length 1)
    if(@middle_name.nil? || @middle_name.empty?)
      @warns[:middle_name] = "Empty Middle Name"
    else
      @middle_name = @middle_name.slice(0, 15) if @middle_name.length > 15
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
	if (@va_schoolid == '8000')
	  @va_schoolid = '8888'
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
      @group_name = @group_name.slice(0, 20) if @group_name.length > 20
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
      if(!@grade.to_s.match(/^(0[0123456789]|-1|1[012]|TT)$/))
        @errors[:grade] = "Invalid Grade: #{@grade}"
      end
    end

    # 13. Gender (Field Length 1)
    if (@gender.nil? || @gender.empty?)
      @errors[:gender] = "No Gender"
    else
      @errors[:gender] = "Invalid Gender" if !@gender.match(/^[MFN]$/)
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
        @errors[:race] = "Invalid Race: #{@race}"
      end
    end

    # 17. Military Connected
    @mil_conn = @mil_conn.to_i
    if (@mil_conn.nil? || @mil_conn < 1 || @mil_conn > 4)
      @errors[:mil_conn] = "Invalid Military Code"
    end

    # 18. MOP Flag
	@mop_flag = @mop_flag.to_i
	if (@mop_flag == 1 || @mop_flag == 2)
	  @mop_flag = "Y"
	else
	  @mop_flag = "N"
	end
	
    # 19. MOP Resident Division (Set by Default)
	if (@mop_flag == "N")
	  @mop_resdiv = nil
	end
	
	# 20. Virtual Virginia (Set by Default)
      
    # 21. Student Number (Field Length 12)
    if (@student_number.nil? || @student_number.zero?)
      @warns[:student_number] = 'No Student Number'
    else
      # Student Numbers must be an integer
      @student_number = @student_number.to_i
      # Field can be no longer than 12 characters
      @student_number = @student_number.to_s.slice(0,12)
    end

    # 22. Student Category - Homeless (Field Length 1)
      if (!@primnight_rescode.nil?)
        if (!@primnight_rescode.to_i.between?(1,4))  
          @errors[:primnight_rescode] = "Invalid PrimNight ResCode"
        end
      end

    # 23. Foster Care
    if (@foster == '1')
      @foster = 'Y'
    else
      @foster = ''
    end

    # 24. N-Code (Free / Reduced) (Field Length 1)
    if ((@n_code == '1') || (!@primnight_rescode.nil? && !@primnight_rescode.empty?))
      @n_code = 'Y'
    else
      @n_code = ''
    end

    # 25. ELL Composite Score (Field Length 2) Range 10-60

    # 26. Disability Code (Field Length 2)
    if (!@dis_code.nil? && !@dis_code.empty?)
      # Pad with leading zero if necessary
      @dis_code = @dis_code.to_s.rjust(2, '0')
      if !@dis_code.match(/(^0[1-9]|1[0234569])$/)
        @errors[:dis_code] = "Invalid Disability Code"
      end
    end

    # 27. Temporary Condition (Set by Default) (Field Length 1)
    
    # 28. Formerly LEP  (Field Length 1)
    if (@formerly_lep.to_s == '4')
	  if (!@ell_comp_score.nil?)
	    @errors[:formerly_lep] = "Can't have Formerly EL of 4 with ELL Score"\
	  end
      @formerly_lep = '4'
    else
      @formerly_lep = nil
    end
    
    # 29. X Code B (Set by Default) (Field Length 1)

    # 30. X Code C (Set by Default) (Field Length 1)
   
    # 31. X Code D (Set by Default) (Field Length 1)
 
    # 32. SOA Adjustment LEP (Set by Default) (Field Length 1)
    if (!@soa_lep.nil? && !@soa_lep.empty? && @soa_lep == 1)
         @soa_lep = 'Y'
    end
    
    # 33. SOA Adjustment Transfer (Field Length 1)
    if (!@soa_trans.nil? && !@soa_trans.empty? && @soa_trans == 1)
         @soa_trans = 'Y'
    end
    
    # 34. Recently Arrived EL (Field Length 1)
    
    # 35. Local Use (Set by Default) (Field Length 9)
    
    # 36. Local Use Test (Set by Default) Field Length 1)

    # 37. Online Testing (Field Length 1)
    if (@online.nil?)
      @online = nil 
    else
      @online = 'Y'
    end
    
    # 38. Session Name  (Set by Default) (Field Length 50)
	
    # 39. Recovery (Set by Default) (Field Length 1)
    if(!@recovery.nil?)
      @recovery = 'Y'
    end

    # 40. Retest (Field Length 1)
    if (!@retest.nil?)
      @retest = 'Y'
    end
    
    # 41. SLIFE (Field Length 1)
    if (@slife != 'Y')
      @slife = ''
    end	

    # 42. Term Grad (Set by Default) (Field Length 1)
    
    # 43. Project Graduation (Field Length 1)
    if (!@proj_grad.nil?)
      @proj_grad = 'Y'
    end
    
    # 44. Parent Requested (Set by Default) (Field Length 1)

    # 45. Z Code E (Set by Default) (Field Length 1)
	
    # 46. Z Code F (Set by Default) (Field Length 1)

    # 47. Z Code G (Set by Default) (Field Length 1)

    # 48. VTLN (Set by Default) (Field Length 1)
    if (@vtln.nil? || @vtln.empty?)
      @warns[:vtln] = "No VTLN Associated"
    end
    
    # 49. TLN (Set by Default) (Field Length 40)
    if (@tln.nil? || @tln.empty?)
      @warns[:tln] = "No Teacher Last Name"
	else
	  @tln.slice(0, 40)
    end
    
    # 50. TFN (Set by Default) (Field Length 25)
    if (@tfn.nil? || @tfn.empty?)
      @warns[:tfn] = "No Teacher First Name"
	else
	  @tfn.slice(0, 25)

    end

    # 51. PNP Calculator (Set by Default) (Field Length 1)
    
    # 52. End of Record (Set by Default) (Field Length 1)
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

