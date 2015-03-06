require 'rubygems'
require 'selenium-webdriver'

describe "Google" do
  it "changes title with keyword" do
	driver = Selenium::WebDriver.for :chrome
	driver.get "http://google.com"

	element = driver.find_element :name => "q"
	element.send_keys "Cheese!"
	element.submit

	puts "Page title is #{driver.title}"

	wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	wait.until { driver.title.downcase.start_with? "cheese!" }

    expect(driver.title.downcase).to include('cheese!')

	puts "Page title is #{driver.title}"
	driver.quit
  end
end

