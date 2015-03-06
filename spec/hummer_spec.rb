require 'rubygems'
require 'selenium-webdriver'

describe "Google" do
  it "changes title with keyword" do
	driver = Selenium::WebDriver.for :phantomjs
	driver.get "http://www.google.com"

	puts "Page title is #{driver.title}"
    expect(driver.title.downcase).not_to include('cheese!')

	element = driver.find_element :name => "q"
	element.send_keys "Cheese!"
	element.submit

	wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	wait.until { driver.title.downcase.start_with? "cheese!" }

	puts "Page title is #{driver.title}"
    expect(driver.title.downcase).to include('cheese!')

	driver.quit
  end
end

