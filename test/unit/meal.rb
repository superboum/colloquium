require_relative 'abstract'

class MealTest < AbstractTest

  def setup

    store = YAML.load_file('config/general.yml') 
    
    @first_meal = store["meal"]["first_meal"]
    @first_day = Date.parse(store["meal"]["first_day"])
    @last_meal = store["meal"]["last_meal"]
    @last_day = Date.parse(store["meal"]["last_day"])

    @m_first = Meal.create_or_find(@first_day,@first_meal).first
    @m_last = Meal.create_or_find(@last_day,@last_meal).first


  end

  def test_create_or_find
    assert_equal @first_meal, @m_first.meal
    assert_equal @first_day,  @m_first.day
  end

  

  def test_comparaison
    m_upper_by_day=Meal.create_or_find(@last_day + 1.day,@last_meal).first
    m_upper_by_meal=Meal.create_or_find(@last_day,@last_meal+1).first
    assert_equal m_upper_by_meal.upper_or_equal_than(@m_first),true
    assert_equal m_upper_by_day.upper_or_equal_than(@m_first),true

    m_lower_by_day=Meal.create_or_find(@first_day-1.day,@first_meal).first
    m_lower_by_meal=Meal.create_or_find(@first_day,@first_meal-1).first
    assert_equal m_lower_by_meal.lower_or_equal_than(@m_last),true
    assert_equal m_lower_by_day.lower_or_equal_than(@m_last),true

    assert_equal @m_first.in_range?,true
    assert_equal @m_last.in_range?,true


    assert_equal m_upper_by_day.in_range?,false
    assert_equal m_upper_by_meal.in_range?,false
    assert_equal m_lower_by_day.in_range?,false
    assert_equal m_lower_by_meal.in_range?,false



  end

  def test_get_day_and_meal
    day,m = Meal.get_day_and_meal(@m_first)


    assert_equal @first_meal, m
    assert_equal @first_day,  day
  end

  def test_convert_int_to_string
    assert_equal Meal.convert_int_to_string(0),"breackfast"
    assert_equal Meal.convert_int_to_string(1),"lunch"
    assert_equal Meal.convert_int_to_string(2),"dinner"
  end

  def test_check_date_format

    params={"first_day" => "20/15/2014","last_day" => "2/05/1994","errors" => {}}
    Meal.check_date_format(params)

    assert_equal params["errors"].has_key?("first_day"),true
    assert_equal params["errors"].has_key?("last_day"),false

    params={"first_day" => "2/05/1994","last_day" => "20/15/2014","errors" => {}}
    Meal.check_date_format(params)

    assert_equal params["errors"].has_key?("first_day"),false
    assert_equal params["errors"].has_key?("last_day"),true
  end

  def test_check_logic_date

    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "25/05/2014","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date(params)
    
    assert_equal params["errors"].has_key?("last_meal"),false
    assert_equal params["errors"].has_key?("last_day"),false


    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>0,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date(params)
    
    assert_equal params["errors"].has_key?("last_meal"),false
    assert_equal params["errors"].has_key?("last_day"),false

    #WRONG DAY
    params={"first_day" => "21/05/2014","last_day" => "20/05/2013","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date(params)

    assert_equal params["errors"].has_key?("last_meal"),false
    assert_equal params["errors"].has_key?("last_day"),true

    #WRONG MEAL
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>1,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date(params)

    assert_equal params["errors"].has_key?("last_meal"),true
    assert_equal params["errors"].has_key?("last_day"),false

  end

  def test_check_params
    #TEST OKAY
    params={"first_day" => "20/05/2014","last_day" => "25/05/2014","first_meal"=>0,"last_meal"=>1,"errors" => {}}
    Meal.check_logic_date(params)
    
    assert_equal params["errors"].empty?,true

    params={"first_day" => "20/15/2014","last_day" => "2/05/1994","errors" => {}}
    Meal.check_date_format(params)

    assert_equal params["errors"].empty?,false

    #WRONG MEAL
    params={"first_day" => "20/05/2014","last_day" => "20/05/2014","first_meal"=>1,"last_meal"=>0,"errors" => {}}
    Meal.check_logic_date(params)

    assert_equal params["errors"].empty?,false

  end


  def test_get_store
    store = Meal.get_store

    assert_equal store,Meal.get_store(store)
    assert_equal store["first_day"].is_a?(Date),true
    assert_equal store["last_day"].is_a?(Date),true
  end

  def test_get_info_from_store
    assert_equal Meal.get_info_from_store.count,7
  end

end
