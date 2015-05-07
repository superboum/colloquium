require_relative 'abstract'

class EventTest < AbstractTest

  def setup
    if User.all.empty?
      @user = User.create(email: "admin@admin.com",password: "admin")
    else
      @user = User.first
    end

    @e_without_felt= Event.new
    @e_without_felt.set({"name"=>"Event", "short_text"=>"Event", "long_text"=>"Long text which fully describe the event", "start_date"=>"2015-05-05 18:00:00 +0200", "end_date"=>"2015-05-05 19:00:00 +0200", "spots_number_limit"=>"0"},@user)
    @e_without_felt.save


  end

  def test_set
    e= Event.new
    e.set({"name"=>"Event", "short_text"=>"Event", "long_text"=>"Long text which fully describe the event", "start_date"=>"2015-05-05 18:00:00 +0200", "end_date"=>"2015-05-05 19:00:00 +0200", "spots_number_limit"=>"0"},@user)
    assert_equal "Event",e.name
    assert_equal "Event",e.short_text
    assert_equal "Long text which fully describe the event",e.long_text
    assert_equal Time.parse("2015-05-05 18:00:00 +0200"),e.start_date
    assert_equal Time.parse("2015-05-05 19:00:00 +0200"),e.end_date
    assert_equal 0,e.spots_number_limit

    e.destroy
  end
 
  
  def test_register_user
    @e_without_felt.register_user(@user,{})
    assert_equal true,@e_without_felt.participants.include?(@user)



  end

  def test_unregister
    @e_without_felt.register_user(@user,{})
    assert_equal true,@e_without_felt.participants.include?(@user)

    @e_without_felt.unregister(@user)
    assert_equal false,@e_without_felt.participants.include?(@user)


  end
  

  def teardown
    @e_without_felt.destroy
  end
end
