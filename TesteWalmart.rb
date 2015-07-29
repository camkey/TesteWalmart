require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "TesteWalmart" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://www.walmart.com.br/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_e_walmart" do
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "suggestion-search").click
    @driver.find_element(:id, "suggestion-search").clear
    @driver.find_element(:id, "suggestion-search").send_keys "TV"
    @driver.find_element(:css, "button.search-icon").click
    element_present?(:link, "Todos os 358 resultados").should be_true
    @driver.find_element(:link, "Todos os 358 resultados").click
    (@driver.find_element(:css, "span.product-title").text).should == "Smart TV LED HD 32\" LG 32LF585B 3 HDMI 3 USB Wi-fi integrado"
    @driver.find_element(:css, "span.product-title").click
    (@driver.find_element(:css, "h1").text).should == "Smart TV LED HD 32\" LG 32LF585B 3 HDMI 3 USB Wi-fi integrado"
    @driver.find_element(:xpath, "//section[@id='buybox-Walmart']/div[2]/div/div[4]/button").click
    @driver.find_element(:id, "navegaCarrinho").click
    @driver.find_element(:css, "span.cart-icon").click
    # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
  end
  
  def element_present?(how, what)
    $receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = $receiver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
