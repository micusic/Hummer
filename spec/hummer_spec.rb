#encoding:UTF-8
require 'rubygems'
require 'selenium-webdriver'
require 'net/http'

describe '51Job' do
  it 'get latest resumes' do
    # driver = Selenium::WebDriver.for :phantomjs
    driver = Selenium::WebDriver.for :chrome
    driver.get 'http://ehire.51job.com/MainLogin.aspx'
    expect(driver.title.downcase).to eq('人才招聘-前程无忧 | 51job 网才')
    puts 'opened 51Job.'

    driver.find_element(:id, 'txtMemberNameCN').send_keys('thoughtworks')
    driver.find_element(:id, 'txtUserNameCN').send_keys('thoughtworks')
    driver.find_element(:id, 'txtPasswordCN').send_keys('tw2015!')
    driver.find_element(:id, 'Login_btnLoginCN').click
    puts 'logged in'
    puts 'got page title is: ' + driver.title.downcase
    if driver.title.downcase == '在线用户管理'
      driver.find_element(:css, 'a').click
      puts 'kicked user'
    end

    expect(driver.title.downcase).to eq('网才')
    driver.get 'http://ehire.51job.com/Candidate/SearchResumeIndex.aspx'
    puts 'at search page'

    puts 'filling filters'
    sleep(2)

    ddlist = driver.find_element(:css, "#DpSearchList")
    select_list = Selenium::WebDriver::Support::Select.new(ddlist)
    select_list.select_by(:text, 'test0111')
    sleep(2)

    driver.find_element(:css, '#btnSearch').click
    puts "clicked and wait"
    sleep(5)

    ids = driver.find_elements(:css, '.SearchR a')
    info_wanted = []
    5.times do |i|
      cur_info = {}
      cur_info[:id] = ids[i].text
      cur_info[:href] = ids[i].attribute('href')
      info_wanted << cur_info
    end

    puts info_wanted

    info_wanted.each do |info|
      driver.get info[:href]
      info[:resume] = driver.find_element(:css, 'div#divResume').attribute 'outerHTML'
    end

    puts info_wanted

    driver.quit
  end
end

