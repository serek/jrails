class JRailsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file 'config/jrails.yml'               , 'config/jrails.yml'
      m.file 'public/javascripts/jquery.js'    , 'public/javascripts/jquery.js'
      m.file 'public/javascripts/jquery-ui.js' , 'public/javascripts/jquery-ui.js'
      m.file 'public/javascripts/jrails.js'    , 'public/javascripts/jrails.js'
    end
  end
end
