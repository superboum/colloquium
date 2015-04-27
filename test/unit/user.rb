require_relative 'abstract'

class UserTest < AbstractTest
  def setup
    @u = User.new

    @params = {
      'first_name' => 'Albert', 
      'last_name' => 'Einstein', 
      'phone' => '000000', 
      'address' => '20 avenue des Buttes de Coesmes', 
      'diet' => 2,
      'nationality' => 'German',
      'title' => 'Doctor',
      'sex' => 2,
      'email' => 'albert@einstein.com',
      'role' => 1,
      'has_paid' => true,
      'password' => 'xxx',
    }
  end

  def test_from_params
    @u.from_params @params

    self.check_basic_value

    assert_nil @u.email
    assert_nil @u.password
    assert_nil @u.role
    assert_nil @u.has_paid

  end
  
  def test_from_params_admin
    @u.from_params_admin @params
    
    self.check_basic_value

    assert_equal @params['role'],     @u.role
    assert_equal @params['has_paid'], @u.has_paid
    assert_equal @params['email'],    @u.email
    refute_nil   @u.password
  end

  def check_basic_value
    assert_equal @params['first_name'],   @u.first_name
    assert_equal @params['last_name'],    @u.last_name
    assert_equal @params['phone'],        @u.phone
    assert_equal @params['address'],      @u.address
    assert_equal @params['diet'],         @u.diet
    assert_equal @params['nationality'],  @u.nationality
    assert_equal @params['title'],        @u.title
    assert_equal @params['sex'],          @u.sex
  end
end
