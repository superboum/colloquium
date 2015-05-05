require_relative 'abstract'

class MealTest < AbstractTest

  def setup
    @app = ColloquiumApp
    @store = YAML.load_file('config/general.yml')
    
    @config_blank = false

    @correct_params={"first_day" => "20/05/2014","last_day" => "25/05/2014","first_meal"=>0,"last_meal"=>1,"lunch" => true, "dinner" => true}

    MealStore.store(@correct_params,@app)

    @first_meal = @store["meal"]["first_meal"]
    @first_day = Date.parse(@store["meal"]["first_day"])
    @last_meal = @store["meal"]["last_meal"]
    @last_day = Date.parse(@store["meal"]["last_day"])

    @m_first = Meal.create_or_find(@first_day,@first_meal).first
    @m_last = Meal.create_or_find(@last_day,@last_meal).first

    @m_upper_by_day=Meal.create_or_find(@last_day + 1.day,@last_meal).first
    @m_upper_by_meal=Meal.create_or_find(@last_day,@last_meal+1).first

    @m_lower_by_day=Meal.create_or_find(@first_day-1.day,@first_meal).first
    @m_lower_by_meal=Meal.create_or_find(@first_day,@first_meal-1).first


  end

  
  def test_create_or_find
    assert_equal  @m_first.meal,@first_meal
    assert_equal  @m_first.day,@first_day
  end

  

  def  test_day_upper_than 

    assert_equal true,@m_upper_by_day.day_upper_than(@m_last)
    assert_equal false,@m_upper_by_meal.day_upper_than(@m_last)

  end

  def  test_upper_than_by_meal
    assert_equal true,@m_upper_by_meal.upper_than_by_meal(@m_last)
    assert_equal false,@m_last.upper_than_by_meal(@m_last)
  end


  def  test_upper_than
    assert_equal true,@m_upper_by_meal.upper_than(@m_last)
    assert_equal true,@m_upper_by_day.upper_than(@m_last)
    assert_equal false,@m_last.upper_than(@m_last)

    assert_equal false,@m_lower_by_meal.upper_than(@m_last)
    assert_equal false,@m_lower_by_day.upper_than(@m_last)
    
  end
  
  def  test_lower_than
    assert_equal true,@m_lower_by_meal.lower_than(@m_last)
    assert_equal true,@m_lower_by_day.lower_than(@m_last)
    assert_equal false,@m_last.lower_than(@m_last)

    assert_equal false,@m_upper_by_meal.lower_than(@m_first)
    assert_equal false,@m_upper_by_day.lower_than(@m_first)
  end
  
  def  test_equal
    assert_equal false,@m_lower_by_day.equal(@m_last)
    assert_equal false,@m_lower_by_meal.equal(@m_last)
    assert_equal true,@m_last.equal(@m_last)
  end
  
  def  test_lower_or_equal_than
    assert_equal true,@m_lower_by_meal.lower_or_equal_than(@m_last)
    assert_equal true,@m_lower_by_day.lower_or_equal_than(@m_last)
    assert_equal true,@m_last.lower_or_equal_than(@m_last)

    assert_equal false,@m_upper_by_meal.lower_or_equal_than(@m_first)
    assert_equal false,@m_upper_by_day.lower_or_equal_than(@m_first)
    
  end

  def  test_upper_or_equal_than
    assert_equal true,@m_upper_by_meal.upper_or_equal_than(@m_first)
    assert_equal true,@m_upper_by_day.upper_or_equal_than(@m_first)
    assert_equal true,@m_last.upper_or_equal_than(@m_last)

    assert_equal false,@m_lower_by_meal.upper_or_equal_than(@m_last)
    assert_equal false,@m_lower_by_day.upper_or_equal_than(@m_last)
  end

  def test_in_range?
    assert_equal true,@m_first.in_range?
    assert_equal true,@m_last.in_range?

    assert_equal false,@m_upper_by_day.in_range?
    assert_equal false,@m_upper_by_meal.in_range?
    assert_equal false,@m_lower_by_day.in_range?
    assert_equal false,@m_lower_by_meal.in_range?
  end

  def test_get_day_and_meal
    day,m = Meal.get_day_and_meal(@m_first)


    assert_equal  m,@first_meal
    assert_equal   day,@first_day
  end

  def test_convert_int_to_string
    assert_equal "breackfast",Meal.convert_int_to_string(0)
    assert_equal "lunch",Meal.convert_int_to_string(1)
    assert_equal "dinner",Meal.convert_int_to_string(2)
  end

  def test_check_date_format

    params={"first_day" => "20/15/2014","last_day" => "2/05/1994","errors" => {}}
    Meal.check_date_format(params)

    assert_equal true,params["errors"].has_key?("first_day")
    assert_equal false,params["errors"].has_key?("last_day")

    params={"first_day" => "2/05/1994","last_day" => "20/15/2014","errors" => {}}
    Meal.check_date_format(params)

    assert_equal false,params["errors"].has_key?("first_day")
    assert_equal true,params["errors"].has_key?("last_day")
  end

  def test_check_logic_date_if_no_error

    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "25/05/2014","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)
    
    assert_equal false,params["errors"].has_key?("last_meal")
    assert_equal false,params["errors"].has_key?("last_day")


    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>0,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)
    
    assert_equal false,params["errors"].has_key?("last_meal")
    assert_equal false,params["errors"].has_key?("last_day")

    #WRONG DAY
    params={"first_day" => "21/05/2014","last_day" => "20/05/2013","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)

    assert_equal false,params["errors"].has_key?("last_meal")
    assert_equal true,params["errors"].has_key?("last_day")

    #WRONG MEAL
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>1,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)

    assert_equal true,params["errors"].has_key?("last_meal")
    assert_equal false,params["errors"].has_key?("last_day")

  end

  def test_check_params
    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "25/05/2014","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)
    
    assert_equal true,params["errors"].empty?

    params={"first_day" => "20/15/2014","last_day" => "2/05/1994","errors" => {}}
    Meal.check_date_format(params)

    assert_equal false,params["errors"].empty?

    #WRONG MEAL
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>1,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date_if_no_error(params)

    assert_equal false,params["errors"].empty?

  end


  def test_get_store

    store = MealStore.get_store

    assert_equal MealStore.get_store(store),store
    assert_equal true,store["first_day"].is_a?(Date)
    assert_equal true,store["last_day"].is_a?(Date)
  end

  def test_get_info_from_store
    assert_equal 7,MealStore.get_info_from_store.count
  end

end
