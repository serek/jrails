# The following options can be changed by creating an initializer in config/initializers/jrails.rb

# jRails uses jQuery.noConflict() by default
# to use the default jQuery varibale, use:
# ActionView::Helpers::PrototypeHelper::JQUERY_VAR = '$'

# ActionView::Helpers::PrototypeHelper:: DISABLE_JQUERY_FORGERY_PROTECTION
# Set this to disable forgery protection in ajax calls
# This is handy if you want to use caching with ajax by injecting the forgery token via another means
# for an example, see http://henrik.nyh.se/2008/05/rails-authenticity-token-with-jquery
# ActionView::Helpers::PrototypeHelper::DISABLE_JQUERY_FORGERY_PROTECTION = true


JRails.load_config
if JRails.google?
  ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = ['jrails']
else
  ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = ['jquery','jquery-ui','jrails']
end
ActionView::Helpers::AssetTagHelper::reset_javascript_include_default


ActionView::Helpers::AssetTagHelper.module_eval do 
  def yield_authenticity_javascript
<<JAVASCRIPT if protect_against_forgery?
<script type='text/javascript'>
 //<![CDATA[
   window._auth_token = '#{form_authenticity_token}';
  $(document).ajaxSend(function(event, xhr, s) {
    if (typeof(window._auth_token) == "undefined") return;
    if (s.data && s.data.match(new RegExp("\\bauthenticity_token="))) return;
    if (s.data)
      s.data += "&";
    else {
      s.data = "";
      xhr.setRequestHeader("Content-Type", s.contentType);
    }
    s.data += "authenticity_token=" + encodeURIComponent(window._auth_token);
  });
 //]]>
</script>
JAVASCRIPT
  end 

  def javascript_include_tag_with_jquery(*source)
    if source.first == :defaults
      javascripts = []
      if JRails.google?
        javascripts \
          << javascript_include_tag_without_jquery(JRails.jquery_path) \
          << javascript_include_tag_without_jquery(JRails.jqueryui_path) \
      end
      javascripts << javascript_include_tag_without_jquery(*source)
      javascripts << yield_authenticity_javascript if protect_against_forgery?
      javascripts.join("\n")
    else
      javascript_include_tag_without_jquery(*source)
    end
  end
  alias_method_chain :javascript_include_tag, :jquery
end
