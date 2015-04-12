#encoding:UTF-8
require 'rubygems'
require 'selenium-webdriver'
require 'net/http'

def write_index(info_wanted)
  index_file = '<!DOCTYPE html>
<html lang="en-us">
  <head>
    <meta charset="UTF-8">
    <title>Hummer by micusic</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="stylesheets/normalize.css" media="screen">
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,700" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css" href="stylesheets/stylesheet.css" media="screen">
    <link rel="stylesheet" type="text/css" href="stylesheets/github-light.css" media="screen">
  </head>
  <body>
    <section class="page-header">
      <a id="hummer" href="index.html" class="project-name">Falcon</a>
      <h2 class="project-tagline">Falcon is powered by Hummer.</h2>
    </section>

    <section class="main-content">


      <div class="resume-link" >'

  info_wanted.each do |info|
    index_file += "<a href='#{info[:id]}.html'>#{info[:id]}</a><br>"
  end
  index_file += '</div>
            <footer class="site-footer">
        <span class="site-footer-owner"><a href="https://github.com/micusic/Hummer">Falcon</a> is maintained by <a href="https://github.com/micusic">micusic</a>.</span>

        <span class="site-footer-credits">This page was generated by <a href="https://pages.github.com">GitHub Pages</a> using the <a href="https://github.com/jasonlong/cayman-theme">Cayman theme</a> by <a href="https://twitter.com/jasonlong">Jason Long</a>.</span>
      </footer>

    </section>

            <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));
          </script>
          <script type="text/javascript">
            try {
              var pageTracker = _gat._getTracker("UA-58520271-2");
            pageTracker._trackPageview();
            } catch(err) {}
          </script>

  </body>
</html>'
  index_path = File.dirname(__FILE__)+"/../Falcon/index.html"
  puts index_path
  f = File.open(index_path, 'w')
  f.puts(index_file)
  f.close
end

def write_resume(info_wanted)
  info_wanted.each do |info|
    cur_resume = '<!DOCTYPE html>
<html lang="en-us">
  <head>
    <meta charset="UTF-8">
    <title>Hummer by micusic</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="stylesheets/normalize.css" media="screen">
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,700" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css" href="stylesheets/stylesheet.css" media="screen">
    <link rel="stylesheet" type="text/css" href="stylesheets/github-light.css" media="screen">
  </head>
  <body>
    <section class="page-header">
      <a id="hummer" href="index.html" class="project-name">Falcon</a>
      <h2 class="project-tagline">Falcon is powered by Hummer.</h2>'
      cur_resume += "<p class='btn'>#{info[:id]}</p>"
      cur_resume += '</section><section class="main-content">'
    cur_resume += info[:resume]
    cur_resume +=   '<footer class="site-footer">
        <span class="site-footer-owner"><a href="https://github.com/micusic/Hummer">Falcon</a> is maintained by <a href="https://github.com/micusic">micusic</a>.</span>

        <span class="site-footer-credits">This page was generated by <a href="https://pages.github.com">GitHub Pages</a> using the <a href="https://github.com/jasonlong/cayman-theme">Cayman theme</a> by <a href="https://twitter.com/jasonlong">Jason Long</a>.</span>
      </footer>

    </section>

            <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));
          </script>
          <script type="text/javascript">
            try {
              var pageTracker = _gat._getTracker("UA-58520271-2");
            pageTracker._trackPageview();
            } catch(err) {}
          </script>

  </body>
</html>'
    file_path = File.dirname(__FILE__)+"/../Falcon/#{info[:id]}.html"
    puts file_path
    f = File.open(file_path, 'w')
    f.puts(cur_resume)
    f.close
  end
end

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

    puts `rm -rf Falcon`
    puts `git clone git@github.com:micusic/Falcon.git`
    puts `cd Falcon && git checkout gh-pages && pwd`

    write_index(info_wanted)

    write_resume(info_wanted)

    puts `cd Falcon && pwd`
    puts `cd Falcon && git add . && git commit -m "auto commit #{Time.now.to_s}" && git push`
  end
end

