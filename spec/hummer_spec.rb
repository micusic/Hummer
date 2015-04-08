#encoding:UTF-8
require 'rubygems'
require 'selenium-webdriver'

describe '51Job' do
  it 'get latest resumes' do
    driver = Selenium::WebDriver.for :phantomjs
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

    baseInfos = driver.find_elements(:xpath,"//tr[contains(@id,'trBaseInfo')]")
    details = driver.find_elements(:xpath,"//tr[contains(@id,'trDetail')]")

    infoWanted = []
    5.times do |i|
      curInfo = {}
      re = baseInfos[i].text.scan /\s*(\S+)\s*/
      curInfo[:id] = re[0][0]
      curInfo[:exp] = re[1][0]
      curInfo[:edu] = re[4][0]
      a='最近工作：'
      b='自我评价：'
      re = details[i].text.scan /.*/
      curInfo[:exjob] = re[0]
      curInfo[:eval] = re[re.size - 2]
      infoWanted << curInfo
    end

    puts infoWanted
    driver.quit

    puts `curl https://install.meteor.com/ | sh`
    puts `meteor`
  end
end

