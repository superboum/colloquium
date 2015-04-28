class Stats
  @nb_of_felts
  @ret
  @felt_key
  @participant_key

  def initialize(e)
    @nb_of_felts = e.form_elements.count

    @ret =  Array.new(e.participants.count+1)
    @felt_key = {}
    @participant_key = {}

    felt_cpt = 2
    @ret[0]=Array.new(2+@nb_of_felts)
    @ret[0][0]="Participant"
    @ret[0][1]="Date of registration"
    e.form_elements.each do |felt|
      @felt_key[felt.id] = felt_cpt
      @ret[0][felt_cpt] = felt.question
      felt_cpt += 1
    end


  end


  def date_management(e,p)
    date = e.users_events.where(user: p).first.created_at
    if(date.nil?) 
      return "Unknown" 
    else 
      return date.strftime("%m/%d/%Y at %I:%M %P")
    end
      
  end

  def fil(e)
    fil_participant(e)
    fil_fa(e)
    return @ret
  end

  def fil_participant(e)    
    ret_cpt = 1
    e.participants.each do |p|
      @participant_key[p.id] = ret_cpt

      @ret[ret_cpt]= Array.new(2+@nb_of_felts)
      @ret[ret_cpt][0]=p.full_name
      @ret[ret_cpt][1] = date_management(e,p)
      ret_cpt += 1
    end
  end

  def fil_fa(e)
    e.form_answers.each do |fa| 
      @ret[@participant_key[fa.participant.id]][@felt_key[fa.form_element.id]]= fa.answer
    end
  end

end

